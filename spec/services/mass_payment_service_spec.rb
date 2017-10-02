require "rails_helper"

describe MassPaymentService do
  let(:admin) { FactoryGirl.create(:auth_admin_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 4) }
  let!(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  context "for invoices" do
    subject { MassPaymentService.new('by_tutor', admin) }

    let(:client) { FactoryGirl.create(:client_user) }
    let(:student) { FactoryGirl.create(:student_user, client: client) }
    let(:engagement) { FactoryGirl.create(:engagement, student: student, student_name: student.name, tutor: tutor, client: client) }
    let!(:invoice_pending) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement) }
    let!(:invoice_pending2) { FactoryGirl.create(:invoice, submitter: tutor, client: client, hourly_rate: client.test_prep_rate, engagement: engagement) }
    let!(:invoice_paid) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: 'paid') }
    let!(:invoice_nil) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, status: nil) }

    it "grabs all pending invoices and creates 1 payment for each user" do
      expect(subject.payments.count).to eq 1
      # factory sets hours for invoice to 2 so each invoice is worth 3000 cents
      expect(subject.payments.sum(&:amount_cents)).to eq 6000
    end

    it "makes multiple payments if there are more than 1 payee" do
      tutor2 = FactoryGirl.create(:tutor_user, outstanding_balance: 2)
      engagement2 = FactoryGirl.create(:engagement, tutor: tutor2, client: client, student_name: client.name)
      invoice2 = FactoryGirl.create(:invoice, submitter: tutor2, client: client, engagement: engagement2)

      expect(subject.payments.count).to eq 2
      expect(subject.payments.sum(&:amount_cents)).to eq 9000
    end

    it "makes all pending invoices to processing" do
      expect(subject.payments.count).to eq 1
      expect(invoice_pending.reload.status).to eq 'processing'
      expect(invoice_pending2.reload.status).to eq 'processing'
      expect(invoice_paid.reload.status).to eq 'paid'
      expect(invoice_nil.reload.status).to be nil
    end

    describe "#update_processing" do
      it "pays all pending invoices" do
        subject.update_processing('paid')

        expect(invoice_pending.reload.status).to eq 'paid'
        expect(invoice_pending2.reload.status).to eq 'paid'
        expect(invoice_paid.reload.status).to eq 'paid'
        expect(invoice_nil.reload.status).to be nil
      end
    end
  end

  context "for timesheets" do
    subject { MassPaymentService.new('by_contractor', admin) }

    it "grabs all pending timesheet" do
      FactoryGirl.create(:invoice, submitter: tutor, submitter_type: 'by_contractor', status: 'pending')
      FactoryGirl.create(:invoice, submitter: tutor, submitter_type: 'by_tutor', status: 'pending')
      FactoryGirl.create(:invoice, submitter: tutor, submitter_type: 'by_contractor', hours: 1, status: 'paid')

      expect(subject.payments.count).to eq 1
      expect(subject.payments.sum(&:amount_cents)).to eq 3000
    end
  end
end
