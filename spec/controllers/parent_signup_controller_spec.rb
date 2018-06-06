require "rails_helper"

 describe Users::ClientsController do
  describe "#creates a parent" do
    let(:user) { FactoryBot.create(:client_user) }
    let!(:tutor) { FactoryBot.create(:tutor_user) }
    let(:subject_id) { FactoryBot.create(:subject).id }
    let(:sign_up_params) { { user: { first_name: "FirstName", last_name: "LastName", phone_number: "(510)555-5555", email: "some_email@example.com",
        password: "some_password", signup_attributes: { student: false, subject_id: subject_id } }, confirm_password: "some_password" } }

    it "does not send notifications to tutor" do
      director = FactoryBot.create(:director_user)

      post :create, params: sign_up_params

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.first.to).to eq(["some_email@example.com"])
    end

    it "sends notifications to director" do
      director = FactoryBot.create(:director_user)

      post :create, params: sign_up_params

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.last.bcc).to include(director.email)
    end

    it "sends notifications to tutor director" do
      tutor.roles << Role.where(name: "director")

      post :create, params: sign_up_params

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.last.bcc).to include(tutor.email)
    end

    it "sends notifications to admin" do
      admin = User.admin

      post :create, params: sign_up_params

      expect(ActionMailer::Base.deliveries.count).to eq(2)
      expect(ActionMailer::Base.deliveries.first.bcc).to include(admin.email)
      expect(ActionMailer::Base.deliveries.last.bcc).to include(admin.email)
    end
  end
end
