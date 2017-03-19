require "rails_helper"

RSpec.describe Api::Signups::UsersController do
  describe '#creates a tutor' do
    let(:user) { FactoryGirl.create(:client_user) }

    it 'with valid parameters' do
      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', client_info_attributes: { subject: "Math", tutoring_for: 1} } }

      expect(response.status).to eq(200)
    end

    it 'with invalid email' do
      post :create, params: { user: { name: 'some name', email: user.email,
        password: 'some_password', client_info_attributes: { subject: "Test Prep", tutoring_for: 1} } }

      expect(response.body).to eq("[\"Email has already been taken\"]")
    end
  end
end
