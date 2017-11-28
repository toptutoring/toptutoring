require "rails_helper"

RSpec.describe Engagement, type: :model do
  it { should validate_presence_of(:client) }
  it { should validate_presence_of(:student_account) }
end
