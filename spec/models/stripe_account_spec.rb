require 'rails_helper'

RSpec.describe StripeAccount, type: :model do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:customer_id) }
end
