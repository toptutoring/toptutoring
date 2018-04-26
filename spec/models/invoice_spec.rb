require "rails_helper"

RSpec.describe Invoice, type: :model do
  context "validations" do
    subject { FactoryBot.create(:invoice) }
    it { should validate_presence_of(:submitter_id) }
    it { should validate_presence_of(:submitter_type) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:hours) }
    context "when submitted by tutor" do
      before :each do
        subject.submitter_type = "by_tutor"
      end
      it { should validate_presence_of(:client_id) }
      it { should validate_presence_of(:engagement_id) }
      it { should validate_presence_of(:subject) }
      it { should validate_presence_of(:hourly_rate_cents) }
      it { should validate_presence_of(:amount_cents) }

      it "validates that session date is not in the future" do
        subject.session_date = Date.tomorrow
        expect(subject.valid?).to be false
      end
    end
  end

  describe ".contractor_pending_total" do
    subject = Invoice
    let(:submitter) { FactoryBot.create(:tutor_user) }

    it "calculates total owed to submitters for pending invoices with submitter type" do
      submitter.create_contractor_account(hourly_rate: 15)
      FactoryBot.create(:invoice, status: "pending", submitter: submitter, submitter_type: "by_contractor")
      FactoryBot.create(:invoice, status: "pending", hours: 1, submitter: submitter, submitter_type: "by_contractor")
      FactoryBot.create(:invoice, status: "paid", submitter: submitter, submitter_type: "by_contractor")
      FactoryBot.create(:invoice, status: "pending", submitter: submitter, submitter_type: "by_tutor")
      FactoryBot.create(:invoice, status: "paid", submitter: submitter, submitter_type: "by_tutor")

      expect(subject.contractor_pending_total.class).to eql(Money)
      expect(subject.contractor_pending_total.cents).to eql(4500)
    end
  end

  describe ".tutor_pending_total" do
    subject = Invoice
    let(:submitter) { FactoryBot.create(:tutor_user) }

    it "calculates total owed to submitters for pending invoices with submitter type" do
      FactoryBot.create(:contractor_account, user: submitter)
      FactoryBot.create(:invoice, status: "pending", hours: 3, submitter: submitter, submitter_type: "by_tutor")
      FactoryBot.create(:invoice, status: "pending", hours: 1, submitter: submitter, submitter_type: "by_tutor")
      FactoryBot.create(:invoice, status: "paid", submitter: submitter, submitter_type: "by_tutor")
      FactoryBot.create(:invoice, status: "pending", submitter: submitter, submitter_type: "by_contractor")
      FactoryBot.create(:invoice, status: "paid", submitter: submitter, submitter_type: "by_contractor")

      expect(subject.tutor_pending_total.class).to eql(Money)
      expect(subject.tutor_pending_total.cents).to eql(6000)
    end
  end
end
