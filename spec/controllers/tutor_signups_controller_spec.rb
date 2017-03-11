require "rails_helper"

RSpec.describe Api::Signups::TutorsController do
  describe '#creates a tutor' do
    before(:all) do
      set_roles
    end
    let(:user) { FactoryGirl.create(:tutor_user) }

    it 'with valid parameters' do
      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', tutor_attributes: { academic_type: "Test Prep"} } }

      expect(response.status).to eq(200)
    end

    it 'with invalid email' do
      post :create, params: { user: { name: 'some name', email: user.email,
        password: 'some_password', tutor_attributes: { academic_type: "Test Prep"} } }

      expect(response.body).to eq("[\"Email has already been taken\"]")
    end
  end
end
