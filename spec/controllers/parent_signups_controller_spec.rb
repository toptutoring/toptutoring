require "rails_helper"

RSpec.describe Api::Signups::UsersController do
  describe '#creates a tutor' do
    let(:user) { FactoryGirl.create(:parent_user) }

    it 'with valid parameters' do
      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', student_attributes: { academic_type: "Test Prep"} } }

      expect(response.status).to eq(200)
    end

    it 'with invalid email' do
      post :create, params: { user: { name: 'some name', email: user.email,
        password: 'some_password', student_attributes: { academic_type: "Test Prep"} } }

      expect(response.body).to eq("[\"Email has already been taken\"]")
    end
  end
end