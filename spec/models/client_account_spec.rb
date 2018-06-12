require 'rails_helper'

RSpec.describe ClientAccount, type: :model do
  let(:client) { FactoryBot.create(:client_user, online_test_prep_rate: 0, in_person_test_prep_rate: 0, in_person_academic_rate: 0) }
  let(:engagement) { FactoryBot.create(:engagement, client_account: client.client_account) }

  context "Validations" do
    it { should validate_presence_of(:user) }

    it "validates presence of review link if review location is present" do
      subject = client.client_account
      subject.assign_attributes(review_source: "location")
      expect(subject.valid?).to be false
    end

    it "validates presence of review location if review link is present" do
      subject = client.client_account
      subject.assign_attributes(review_link: "https://www.example.com")
      expect(subject.valid?).to be false
    end

    it "should be valid if both location and link is provided" do
      subject = client.client_account
      subject.assign_attributes(review_source: "location", review_link: "https://www.example.com")
      expect(subject.valid?).to be true
    end

    it "validates review link to be valid url" do
      subject = client.client_account
      subject.assign_attributes(review_source: "location", review_link: "not url")
      expect(subject.valid?).to be false
    end
  end

  describe "#academic_types_engaged" do
    it "returns only the types engaged where rate is greater than 0" do
      expect(client.client_account.academic_types_engaged).to contain_exactly("online_academic")
    end
  end

  describe "#request_review?" do
    it "returns false if client already has a review" do
      FactoryBot.create(:client_review, client_account: client.client_account)
      expect(client.client_account.request_review?).to eq false
    end

    it "returns false if client has no invoices" do
      expect(client.client_account.request_review?).to eq false
    end

    it "returns false if client has many invoices but they are less than 4 stars" do
      3.times do
        FactoryBot.create(:invoice, client: client, session_rating: 3, engagement: engagement)
      end

      expect(client.client_account.request_review?).to eq false
    end

    it "returns true if client has two invoices and one is at least 4 stars" do
      2.times do
        FactoryBot.create(:invoice, client: client, session_rating: 3, engagement: engagement)
      end
      client.client_account.invoices.last.update(session_rating: 4)

      expect(client.client_account.request_review?).to eq true
    end
  end
end
