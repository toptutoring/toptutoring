require 'rails_helper'

RSpec.describe ClientAccount, type: :model do
  it { should validate_presence_of(:user) }

  let(:client) { FactoryGirl.create(:client_user) }

  describe "#academic_types_engaged" do
    it "returns only the types engaged" do
      subject = client.client_account
      FactoryGirl.create(:engagement, client_account: subject)

      expect(subject.academic_types_engaged).to contain_exactly("academic")

      FactoryGirl.create(:engagement, client_account: subject, subject: FactoryGirl.create(:subject, academic_type: "test_prep"))

      expect(subject.academic_types_engaged).to contain_exactly("academic", "test_prep")
    end
  end
end
