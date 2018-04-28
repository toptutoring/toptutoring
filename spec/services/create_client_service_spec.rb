require "rails_helper"

describe CreateClientService do
  describe ".create!" do
    let(:user_params) { { first_name: "ClientName",
                          last_name: "ClientLastName",
                          phone_number: "510-555-5555",
                          email: "client_new@example.com",
                          password: "password", country_code: "US",
                          signup_attributes: { student: false,
                                               subject: FactoryBot.create(:subject),
                                               comments: "Hello"} } }
    let(:student_params) { { first_name: "StudentName",
                             last_name: "StudentLastName",
                             phone_number: "510-555-5555",
                             email: "client_new@example.com",
                             password: "password", country_code: "US",
                             signup_attributes: { student: true,
                                                  subject: FactoryBot.create(:subject),
                                                  comments: "Hello"} } }
    let(:invalid_params) { { first_name: "Student",
                             last_name: "StudentLastName",
                             phone_number: "510-555-5555",
                             email: "client_new@example.com",
                             password: "password", country_code: "US",
                             signup_attributes: { student: true,
                                                  subject: nil, # Subject is invalid
                                                  comments: "Hello"} } }

    it "creates user successfully when user is not a student" do
      subject = CreateClientService.create!(user_params, "password")

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.first_name).to eq user_params[:first_name]
      expect(subject.user.last_name).to eq user_params[:last_name]
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be false
      expect(subject.user.student_account).to be nil
      expect(subject.user.signup.student).to be false
      expect(subject.user.country_code).to eq "US"
    end

    it "creates user successfully when user is from a different country" do
      user_params[:phone_number] = "02-312-3456"
      user_params[:country_code] = "KR"
      subject = CreateClientService.create!(user_params, "password")

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.first_name).to eq user_params[:first_name]
      expect(subject.user.last_name).to eq user_params[:last_name]
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be false
      expect(subject.user.student_account).to be nil
      expect(subject.user.signup.student).to be false
      expect(subject.user.country_code).to eq "KR"
    end

    it "creates user successfully when user is not a student" do
      subject = CreateClientService.create!(user_params, "password")

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.first_name).to eq user_params[:first_name]
      expect(subject.user.last_name).to eq user_params[:last_name]
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be false
      expect(subject.user.student_account).to be nil
      expect(subject.user.signup.student).to be false
    end

    it "fails when params aren't valid" do
      subject = CreateClientService.create!(invalid_params, "password")

      expect(subject.success?).to be false
      expect(subject.user.persisted?).to be false
    end

    it "fails when phone number is invalid" do
      user_params[:phone_number] = "510555"
      subject = CreateClientService.create!(user_params, "password")

      expect(subject.success?).to be false
      expect(subject.user.persisted?).to be false
    end

    it "fails when phone number is invalid for a different country" do
      user_params[:phone_number] = "02-312-345"
      user_params[:country_code] = "KR"
      subject = CreateClientService.create!(user_params, "password")

      expect(subject.success?).to be false
      expect(subject.user.persisted?).to be false
    end

    it "fails when passwords do not match" do
      subject = CreateClientService.create!(invalid_params, "notpassword")

      expect(subject.success?).to be false
      expect(subject.messages).to eq I18n.t("app.signup.password_fail") 
      expect(subject.user.persisted?).to be false
    end
  end
end
