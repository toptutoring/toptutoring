require "rails_helper"

describe MassPaymentService do
  let(:admin) { FactoryGirl.create(:auth_admin_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user, outstanding_balance: 20) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:contract) { FactoryGirl.create(:contract, user_id: tutor.id) }
  let!(:engagement) { FactoryGirl.create(:engagement, student: student, student_name: student.name, tutor: tutor, client: client) }
  let!(:funding_source) { FactoryGirl.create(:funding_source, user_id: admin.id) }

  context "for invoices" do
    subject { MassPaymentService.new('invoice', admin) }

    it "grabs all pending invoices" do
      invoice_pending = FactoryGirl.create(:invoice, tutor_id: tutor.id, client: client, engagement: engagement, status: 'pending')
      invoice_paid = FactoryGirl.create(:invoice, tutor_id: tutor.id, client: client, engagement: engagement, status: 'paid')
      invoice_nil = FactoryGirl.create(:invoice, tutor_id: tutor.id, client: client, engagement: engagement, status: nil)

      expect(subject.payments.count).to eq 1
      expect(subject.payments.sum(&:amount_in_cents)).to eq 3000
    end
  end

  context "for timesheets" do
    subject { MassPaymentService.new('timesheet', admin) }

    it "grabs all pending timesheet" do
      timesheet_pending = Timesheet.create(user_id: tutor.id, date: Date.yesterday, minutes: 60, status: 'pending')
      timesheet_paid = Timesheet.create(user_id: tutor.id, date: Date.yesterday, minutes: 60, status: 'paid')

      expect(subject.payments.count).to eq 1
      expect(subject.payments.sum(&:amount_in_cents)).to eq 1500
    end
  end
end
