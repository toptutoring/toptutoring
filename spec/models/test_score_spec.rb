require 'rails_helper'

RSpec.describe TestScore, type: :model do
  it { should belong_to(:tutor_account) }
  it { should belong_to(:subject) }
end
