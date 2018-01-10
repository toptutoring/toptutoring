require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:publish_date) }
  it { should validate_presence_of(:user) }
  it { should belong_to(:user) }
end
