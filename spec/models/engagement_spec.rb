require "rails_helper"

RSpec.describe Engagement, type: :model do
  it { should validate_presence_of(:client_account) }
  it { should validate_presence_of(:student_account) }

  describe "#able_to_enable?" do
    it "returns true if engagement is pending and has tutor set" do
      subject = FactoryBot.build(:engagement, state: "pending")
      expect(subject.able_to_enable?).to be true
    end

    it "returns true if engagement is archived" do
      subject = FactoryBot.build(:engagement, state: "archived")
      expect(subject.able_to_enable?).to be true
    end

    it "returns false if engagement is pending but there is no tutor" do
      subject = FactoryBot.build(:engagement, state: "pending", tutor_account: nil)
      expect(subject.able_to_enable?).to be false
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
end
