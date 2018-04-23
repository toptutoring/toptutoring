require 'rails_helper'

RSpec.describe City, type: :model do
  let(:country) { Struct.new(:code).new('us') }
  subject { FactoryBot.create(:city, name: 'Los Angeles', state: 'CA') }
  before { allow(subject).to receive(:country).and_return(country) }

  describe "validations" do
    it { should belong_to(:country) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of (:country_id) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_uniqueness_of(:slug).ignoring_case_sensitivity }
  end

  describe "#add_slug" do
    it "adds a slug consisting of the city name and state" do
      subject.add_slug
      expect(subject.slug).to eq("los-angeles-ca-tutoring")
    end
  end
end