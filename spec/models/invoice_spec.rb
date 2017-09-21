require "rails_helper"

RSpec.describe Invoice, type: :model do
  it { should validate_presence_of(:tutor_id) }
  it { should validate_presence_of(:client_id) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:hours) }
end
