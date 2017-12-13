require 'rails_helper'

RSpec.describe TutorAccount, type: :model do
  it { should validate_presence_of(:user) }
  it { should have_and_belong_to_many(:subjects) }
  it { should have_many(:engagements) }
  it { should have_many(:student_accounts) }
  it { should have_one(:contract) }
end
