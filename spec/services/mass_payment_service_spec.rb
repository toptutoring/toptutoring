require "rails_helper"

describe MassPaymentService do
  let(:admin) { FactoryBot.create(:auth_admin_user) }
  let(:tutor) { FactoryBot.create(:tutor_user, outstanding_balance: 4) }
  let!(:funding_source) { FactoryBot.create(:funding_source, user_id: admin.id) }

  context "for invoices" do
    subject { MassPaymentService.new("by_tutor", admin) }

    let(:client) { FactoryBot.create(:client_user) }
    let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
    let(:student_account_user_nil) { FactoryBot.create(:student_account, user: nil, client_account: client.client_account) }
    let(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account) }
    let!(:invoice_pending) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement) }
    let!(:invoice_pending2) { FactoryBot.create(:invoice, submitter: tutor, client: client, hourly_rate: client.online_test_prep_rate, engagement: engagement) }
    let!(:invoice_paid) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: "paid") }
    let!(:invoice_nil) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: nil) }

    it "grabs all pending invoices and creates 1 payment for each user" do
      expect(subject.payouts.count).to eq 1
      # factory sets hours for invoice to 2 so each invoice is worth 3000 cents
      expect(subject.payouts.sum(&:amount_cents)).to eq 6000
    end

    it "makes multiple payments if there are more than 1 payee" do
      tutor2 = FactoryBot.create(:tutor_user, outstanding_balance: 2)
      engagement2 = FactoryBot.create(:engagement, tutor_account: tutor2.tutor_account, client_account: client.client_account, student_account: student_account_user_nil)
      invoice2 = FactoryBot.create(:invoice, submitter: tutor2, client: client, engagement: engagement2)

      expect(subject.payouts.count).to eq 2
      expect(subject.payouts.sum(&:amount_cents)).to eq 9000
    end

    it "makes all pending invoices to processing" do
      expect(subject.payouts.count).to eq 1
      expect(invoice_pending.reload.status).to eq "processing"
      expect(invoice_pending2.reload.status).to eq "processing"
      expect(invoice_paid.reload.status).to eq "paid"
      expect(invoice_nil.reload.status).to be nil
    end

    it "records correct data for payment" do
      expect(Payout.count).to eq 0
      total_to_be_paid = tutor.invoices.pending.sum(:submitter_pay_cents)
      VCR.use_cassette("dwolla_mass_payment", match_requests_on: [:method, :path]) do
        subject.pay_all
      end
      expect(Payout.count).to eq 1
      payout = Payout.last
      expect(payout.dwolla_transfer_url).not_to be_nil
      expect(payout.payee).to eq tutor
      expect(payout.destination).to eq tutor.auth_uid
      expect(payout.amount.cents).to eq total_to_be_paid
      expect(payout.funding_source).to eq funding_source.funding_source_id
      expect(payout.approver).to eq admin
      expect(payout.description).to eq "Payment for invoices: #{invoice_pending.id}, #{invoice_pending2.id}."
    end

    describe "#update_processing" do
      it "pays all pending invoices" do
        subject.update_processing("paid")

        expect(invoice_pending.reload.status).to eq "paid"
        expect(invoice_pending2.reload.status).to eq "paid"
        expect(invoice_paid.reload.status).to eq "paid"
        expect(invoice_nil.reload.status).to be nil
      end
    end
  end

  context "for timesheets" do
    subject { MassPaymentService.new("by_contractor", admin) }

    it "grabs all pending timesheet" do
      FactoryBot.create(:contractor_account, hourly_rate: 15, user: tutor)
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_contractor", status: "pending")
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_tutor", status: "pending")
      FactoryBot.create(:invoice, submitter: tutor, submitter_type: "by_contractor", hours: 1, status: "paid")

      expect(subject.payouts.count).to eq 1
      expect(subject.payouts.sum(&:amount_cents)).to eq 3000
    end
  end
end
