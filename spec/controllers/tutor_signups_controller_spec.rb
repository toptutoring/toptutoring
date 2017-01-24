require "rails_helper"

RSpec.describe Api::Signups::TutorsController do
  describe '#creates a tutor' do
    let(:user) { FactoryGirl.create(:tutor_user) }

    describe 'with valid credentials' do
      it 'with valid parameters' do
        request.headers['HTTP_API_APPLICATION_KEY'] = ENV.fetch('API_APPLICATION_KEY')
        post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
          password: 'some_password', tutor_attributes: { academic_type: "Test Prep"} } }

        expect(response.status).to eq(200)
      end

      it 'with invalid email' do
        request.headers['HTTP_API_APPLICATION_KEY'] = ENV.fetch('API_APPLICATION_KEY')
        post :create, params: { user: { name: 'some name', email: user.email,
          password: 'some_password', tutor_attributes: { academic_type: "Test Prep"} } }

        expect(response.body).to eq("[\"Email has already been taken\"]")
      end
    end

    describe 'with invalid credentials' do
      it 'with valid parameters' do
        post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
          password: 'some_password', tutor_attributes: { academic_type: "Test Prep"} } }

        expect(response.status).to eq(401)
        expect(response.message).to eq("Unauthorized")
      end

      it 'with invalid email' do
        post :create, params: { user: { name: 'some name', email: user.email,
          password: 'some_password', tutor_attributes: { academic_type: "Test Prep"} } }

        expect(response.status).to eq(401)
        expect(response.message).to eq("Unauthorized")
      end
    end
  end
end
