require "rails_helper"

 describe Users::ClientsController do
  describe '#creates a parent' do
    let(:user) { FactoryGirl.create(:client_user) }
    let!(:tutor) { FactoryGirl.create(:tutor_user) }

    it 'does not send notifications to tutor' do
      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', signup_attributes: { student: false } } }

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to).to eq(['some_email@toptutoring.com'])
    end

    it 'sends notifications to director' do
      director = FactoryGirl.create(:director_user)

      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', signup_attributes: { student: false } } }

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.map(&:to)).to include([director.email])
    end

    it 'sends notifications to tutor director' do
      tutor.roles = "director"
      tutor.save

      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', signup_attributes: { student: false } } }

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.map(&:to)).to include([tutor.email])
    end

    it 'sends notifications to admin' do
      admin = FactoryGirl.create(:admin_user)

      post :create, params: { user: { name: 'some name', email: 'some_email@toptutoring.com',
        password: 'some_password', signup_attributes: { student: false } } }

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.map(&:to)).to include([admin.email])
    end
  end
end
