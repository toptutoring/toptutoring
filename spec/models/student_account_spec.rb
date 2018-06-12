require 'rails_helper'

RSpec.describe StudentAccount, type: :model do
  it { should validate_presence_of(:client_account) }
  it { should validate_presence_of(:name) }

  let(:student) { FactoryBot.create(:student_user) }
end
