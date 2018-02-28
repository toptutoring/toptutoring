require "rails_helper"

describe CreateClientService do
  describe ".create!" do
    let(:user_params) { { name: "Client",
                          phone_number: "510-555-5555",
                          email: "client_new@example.com",
                          password: "password",
                          signup_attributes: { student: false,
                                               subject: FactoryBot.create(:subject),
                                               comments: "Hello"} } }
    let(:student_params) { { name: "Student",
                             phone_number: "510-555-5555",
                             email: "client_new@example.com",
                             password: "password",
                             signup_attributes: { student: true,
                                                  subject: FactoryBot.create(:subject),
                                                  comments: "Hello"} } }
    let(:invalid_params) { { name: "Student",
                             phone_number: "510-555-5555",
                             email: "client_new@example.com",
                             password: "password",
                             signup_attributes: { student: true,
                                                  subject: nil, # Subject is invalid
                                                  comments: "Hello"} } }

    it "creates user successfully when user is not a student" do
      subject = CreateClientService.create!(user_params, "US")

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.name).to eq "Client"
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be false
      expect(subject.user.student_account).to be nil
      expect(subject.user.signup.student).to be false
    end

    it "creates user successfully when user is a student" do
      subject = CreateClientService.create!(student_params, "US")

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.name).to eq "Student"
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be true
      expect(subject.user.student_account).not_to be nil
      expect(subject.user.signup.student).to be true
    end

    it "fails when params aren't valid" do
      subject = CreateClientService.create!(invalid_params, "US")

      expect(subject.success?).to be false
      expect(subject.user.persisted?).to be false
    end
  end
end
