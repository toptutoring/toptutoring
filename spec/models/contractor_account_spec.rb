require 'rails_helper'

RSpec.describe ContractorAccount, type: :model do
  it { should validate_presence_of(:user) }
  it { should have_one(:contract) }
end
