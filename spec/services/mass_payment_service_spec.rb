require "rails_helper"
# Dwolla stub for this spec is defined in spec/support/dwolla_service_stub.rb

describe MassPaymentService do
  subject = MassPaymentService
  let(:admin) { FactoryBot.create(:auth_admin_user) }
  let(:tutor) { FactoryBot.create(:tutor_user, outstanding_balance: 4) }
  let!(:funding_source) { FactoryBot.create(:funding_source, user_id: admin.id) }

  context "for invoices" do
    let(:client) { FactoryBot.create(:client_user) }
    let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
    let(:student_account_user_nil) { FactoryBot.create(:student_account, user: nil, client_account: client.client_account) }
    let(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account) }
    let!(:invoice_pending) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement) }
    let!(:invoice_pending2) { FactoryBot.create(:invoice, submitter: tutor, client: client, hourly_rate: client.online_test_prep_rate, engagement: engagement) }
    let!(:invoice_paid) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "paid") }
    let!(:invoice_nil) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: nil) }
    # factory sets hours for invoice to 2 so each invoice is worth 30_00 cents

    it "grabs all pending invoices and creates 1 payment for each user" do
      expect(Payout.count).to eq 0
      expected_payment_description = "Payment for invoices: #{tutor.invoices.pending.ids.join(', ')}."

      mass_pay_stub true, [ { metadata: { auth_uid: tutor.auth_uid }, status: "success", _links: { transfer: { href: "transfer_url" } } } ]

      request = subject.new(Invoice.pending.by_tutor.group_by(&:submitter), admin).pay_all

      expect(request.success?).to be true
      expect(request.message).to contain_exactly "1 payment has been made for a total of $60.00."
      expect(Payout.count).to eq 1
      expect(Payout.sum(:amount_cents)).to eq 60_00
      expect(Payout.last.dwolla_transfer_url).to eq "transfer_url"
      expect(Payout.last.description).to eq expected_payment_description
      expect(Payout.last.destination).to eq tutor.auth_uid
      expect(Payout.last.funding_source).to eq funding_source.funding_source_id
    end

    it "does not make any payouts and sets invoices back to pending if dwolla api request fails" do
      expect(Payout.count).to eq 0
      count = tutor.invoices.pending.count
      error = "Error Message"
      failed_mass_pay_stub error

      request = subject.new(Invoice.pending.by_tutor.group_by(&:submitter), admin).pay_all

      expect(request.success?).to be false
      expect(request.message).to contain_exactly error
      expect(Payout.count).to eq 0
      expect(tutor.reload.invoices.pending.count).to eq count
    end

    it "makes multiple payments if there are more than 1 payee" do
      tutor2 = FactoryBot.create(:tutor_user, auth_uid: "another_uid", outstanding_balance: 2)
      engagement2 = FactoryBot.create(:engagement, tutor_account: tutor2.tutor_account, client_account: client.client_account, student_account: student_account_user_nil)
      FactoryBot.create(:invoice, submitter: tutor2, client: client, engagement: engagement2)

      tutor_expected_payment_description = "Payment for invoices: #{tutor.invoices.pending.ids.join(', ')}."
      tutor2_expected_payment_description = "Payment for invoices: #{tutor2.invoices.pending.ids.join(', ')}."

      mass_pay_stub true, [ { metadata: { auth_uid: tutor.auth_uid }, status: "success", _links: { transfer: { href: "transfer_url" } } },
                            { metadata: { auth_uid: tutor2.auth_uid }, status: "success", _links: { transfer: { href: "transfer_url2" } } } ]

      request = subject.new(Invoice.pending.by_tutor.group_by(&:submitter), admin).pay_all

      tutor_payout = Payout.find_by destination: tutor.auth_uid
      tutor2_payout = Payout.find_by destination: tutor2.auth_uid

      expect(request.success?).to be true
      expect(request.message).to contain_exactly "2 payments have been made for a total of $90.00."
      expect(Payout.count).to eq 2
      expect(Payout.sum(:amount_cents)).to eq 90_00
      expect(tutor_payout.dwolla_transfer_url).to eq "transfer_url"
      expect(tutor_payout.description).to eq tutor_expected_payment_description
      expect(tutor2_payout.dwolla_transfer_url).to eq "transfer_url2"
      expect(tutor2_payout.description).to eq tutor2_expected_payment_description
    end

    it "makes all pending invoices to processing" do
      subject.new(Invoice.pending.by_tutor.group_by(&:submitter), admin)
      expect(invoice_pending.reload.status).to eq "processing"
      expect(invoice_pending2.reload.status).to eq "processing"
      expect(invoice_paid.reload.status).to eq "paid"
      expect(invoice_nil.reload.status).to be nil
    end
  end

  context "for timesheets" do
    it "pays only pending timesheets" do
      FactoryBot.create(:contractor_account, user: tutor)
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_contractor", status: "pending")
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_tutor", status: "pending")
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_contractor", hours: 1, status: "paid")
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_contractor", hours: 1, status: "pending")

      mass_pay_stub true, [ { metadata: { auth_uid: tutor.auth_uid }, status: "success", _links: { transfer: { href: "transfer_url" } } } ]

      request = subject.new(Invoice.pending.by_contractor.group_by(&:submitter), admin).pay_all

      expect(request.success?).to be true
      expect(request.message).to contain_exactly "1 payment has been made for a total of $45.00."
      expect(Payout.count).to eq 1
      expect(Payout.sum(:amount_cents)).to eq 45_00
    end
  end
end
