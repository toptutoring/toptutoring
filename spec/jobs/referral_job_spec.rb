require "rails_helper"

describe ReferralJob, type: :job do
  include ActiveJob::TestHelper
  let(:referrer) { FactoryBot.create(:client_user, in_person_test_prep_credit: 1, in_person_test_prep_rate_cents: 100_00) }
  let!(:referred_client) { FactoryBot.create(:client_user, referrer: referrer) }
  subject = ReferralJob

  describe ".perform" do
    it "adds an hour to referrer and marks referral_claimed to true" do
      original_credit = referrer.in_person_test_prep_credit
      subject.perform_now(referred_client.id)

      expect(referred_client.reload.referral_claimed).to be_truthy
      expect(referrer.reload.in_person_test_prep_credit).to eq original_credit + 1
      expect(referrer.in_person_academic_credit).to eq 0
      expect(referrer.online_academic_credit).to eq 0
      expect(referrer.online_test_prep_credit).to eq 0
    end

    it "doesn't add credits if referral already claimed" do
      original_credit = referrer.in_person_test_prep_credit
      referred_client.update(referral_claimed: true)
      subject.perform_now(referred_client.id)

      expect(referred_client.reload.referral_claimed).to be_truthy
      expect(referrer.reload.in_person_test_prep_credit).to eq original_credit
      expect(referrer.in_person_academic_credit).to eq 0
      expect(referrer.online_academic_credit).to eq 0
      expect(referrer.online_test_prep_credit).to eq 0
    end
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end
end
