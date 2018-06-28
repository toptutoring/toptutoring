require "rails_helper"

RSpec.describe Engagement, type: :model do
  it { should validate_presence_of(:client_account) }
  it { should validate_presence_of(:student_account) }

  let(:client) { FactoryBot.create(:client_user) }
  let(:test_subject) { FactoryBot.create(:subject, academic_type: "test_prep") }
  let(:academic_subject) { FactoryBot.create(:subject, academic_type: "academic") }

  describe "#can_enable?" do
    it "returns true if engagement is pending and has tutor set" do
      subject = FactoryBot.build(:engagement, state: "pending")
      expect(subject.can_enable?).to be true
    end

    it "returns true if engagement is archived" do
      subject = FactoryBot.build(:engagement, state: "archived")
      expect(subject.can_enable?).to be true
    end

    it "returns false if engagement is pending but there is no tutor" do
      subject = FactoryBot.build(:engagement, state: "pending", tutor_account: nil)
      expect(subject.can_enable?).to be false
    end

    it "cannot be enabled if rates for user are not set" do
      client.update(online_academic_rate: 0, in_person_academic_rate: 0)
      subject = FactoryBot.create(:engagement, state: "pending", subject: academic_subject, client_account: client.client_account)
      expect(subject.can_enable?).to be false
    end
  end

  describe "#able_to_delete?" do
    it "returns false if engagement has invoices" do
      subject = FactoryBot.build(:engagement, state: "pending", tutor_account: nil)
      subject.invoices << FactoryBot.build(:invoice)
      expect(subject.able_to_delete?).to be false
    end

    it "returns false if engagement is active and has no invoices" do
      subject = FactoryBot.build(:engagement, state: "active", tutor_account: nil)
      expect(subject.able_to_delete?).to be false
    end

    it "returns true if engagement has no invoices and is pending" do
      subject = FactoryBot.build(:engagement, state: "pending", tutor_account: nil)
      expect(subject.able_to_delete?).to be true
    end

    it "returns true if engagement has no invoices and is archived" do
      subject = FactoryBot.build(:engagement, state: "archived", tutor_account: nil)
      expect(subject.able_to_delete?).to be true
    end
  end

  describe "#credits_remaining?" do
    it "returns true if client has credits for online test type" do
      client.update(online_test_prep_credit: 1)
     subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be true
    end

    it "returns true if client has credits for in person test type" do
      client.update(in_person_test_prep_credit: 1)
      subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be true
    end

    it "returns true if client has credits for online academic type" do
      client.update(online_academic_credit: 1)
     subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be true
    end

    it "returns true if client has credits for in person test type" do
      client.update(in_person_academic_credit: 1)
      subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be true
    end

    it "returns false if client has 0 or less credits for test" do
      subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be false
    end

    it "returns false if client has 0 or less credits for academic" do
      subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be false
    end

    it "returns false if client has credits for different type than test" do
      client.update(in_person_academic_credit: 1)
      subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be false
    end

    it "returns false if client has credits for different type than academic" do
      client.update(in_person_test_prep_credit: 1)
      subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.credits_remaining?).to be false
    end
  end

  describe "#low_balance?" do
    it "returns true if client has credits for online but none for in person test type" do
      client.update(in_person_test_prep_credit: -1, online_test_prep_credit: 1)
     subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.low_balance?).to be true
    end

    it "returns true if client has credits for in person but none for online test type" do
      client.update(in_person_test_prep_credit: 1, online_test_prep_credit: -1)
      subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.low_balance?).to be true
    end

    it "returns true if client has no credits for any type" do
      client.update(in_person_academic_credit: -1, online_academic_credit: -1)
      subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.low_balance?).to be true
    end

    it "returns false if client has credits for all relevant credits" do
      client.update(online_academic_credit: 1, in_person_academic_credit: 1)
     subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.low_balance?).to be false
    end

    it "returns true if client has credits for different type than test" do
      client.update(in_person_academic_credit: 1, in_person_test_prep_credit: -1, online_test_prep_credit: -1)
      subject = FactoryBot.create(:engagement, subject: test_subject, client_account: client.client_account)
      expect(subject.low_balance?).to be true
    end

    it "returns true if client has credits for different type than academic" do
      client.update(in_person_test_prep_credit: 1, in_person_academic_credit: -1, online_academic_credit: -1)
      subject = FactoryBot.create(:engagement, subject: academic_subject, client_account: client.client_account)
      expect(subject.low_balance?).to be true
    end
  end
end
