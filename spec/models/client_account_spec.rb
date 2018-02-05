require 'rails_helper'

RSpec.describe ClientAccount, type: :model do
  it { should validate_presence_of(:user) }

  let(:client) { FactoryBot.create(:client_user, online_test_prep_rate: 0, in_person_test_prep_rate: 0, in_person_academic_rate: 0) }

  describe "#academic_types_engaged" do
    it "returns only the types engaged where rate is greater than 0" do
      expect(client.client_account.academic_types_engaged).to contain_exactly("online_academic")
    end
  end
end
