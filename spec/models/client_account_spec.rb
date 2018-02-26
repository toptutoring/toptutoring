require 'rails_helper'

RSpec.describe ClientAccount, type: :model do
  let(:client) { FactoryBot.create(:client_user, online_test_prep_rate: 0, in_person_test_prep_rate: 0, in_person_academic_rate: 0) }

  it { should validate_presence_of(:user) }

  describe "#academic_types_engaged" do
    it "returns only the types engaged where rate is greater than 0" do
      expect(client.client_account.academic_types_engaged).to contain_exactly("online_academic")
    end
  end

  describe "#send_review_email" do
    let(:engagement) { FactoryBot.create(:engagement, client_account: client.client_account) }

    it "returns true if review should be requested" do
      3.times do 
        FactoryBot.create(:invoice, session_rating: 5, engagement: engagement, submitter: engagement.tutor_account.user)
      end
      expect(client.client_account.send_review_email?).to be_truthy
    end

    it "returns false if review has already been requested" do
      3.times do 
        FactoryBot.create(:invoice, session_rating: 5, engagement: engagement, submitter: engagement.tutor_account.user)
      end
      client.client_account.update(review_requested: true)
      expect(client.client_account.send_review_email?).to be_falsey
    end

    it "returns false if client has less than 3 invoices" do
      2.times do 
        FactoryBot.create(:invoice, session_rating: 5, engagement: engagement, submitter: engagement.tutor_account.user)
      end
      expect(client.client_account.send_review_email?).to be_falsey
    end

    it "returns false if client has no 5 star session ratings" do
      3.times do 
        FactoryBot.create(:invoice, session_rating: 4, engagement: engagement, submitter: engagement.tutor_account.user)
      end
      expect(client.client_account.send_review_email?).to be_falsey
    end
  end
end
