require 'rails_helper'

RSpec.describe City, type: :model do
  let(:country) { Struct.new(:code).new('us') }
  before { allow(subject).to receive(:country).and_return(country) }

  it { should belong_to(:country) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of (:country_id) }
  it { should validate_presence_of(:phone_number) }

  let(:city) { FactoryBot.create(:city, name: 'Los Angeles', state: 'CA') }
  describe "#add_slug" do
    it "adds a slug consisting of the city name and state" do
      expect(city.add_slug).to eq("los-angeles-ca-tutoring")
    end
  end
end