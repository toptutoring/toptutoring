require "rails_helper"

describe CreateClientService do
  describe ".create!" do
    let(:user_params) { { name: "Client",
                          email: "client_new@example.com",
                          password: "password",
                          signup_attributes: { student: false,
                                               subject: FactoryGirl.create(:subject),
                                               comments: "Hello"} } }
    let(:student_params) { { name: "Student",
                             email: "client_new@example.com",
                             password: "password",
                             signup_attributes: { student: true,
                                                  subject: FactoryGirl.create(:subject),
                                                  comments: "Hello"} } }

    it "creates user successfully when user is not a student" do
      subject = CreateClientService.create!(user_params)

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.name).to eq "Client"
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be false
      expect(subject.user.student_account).to be nil
      expect(subject.user.is_student?).to be false
    end

    it "creates user successfully when user is a student" do
      subject = CreateClientService.create!(student_params)

      expect(subject.success?).to be true
      expect(subject.user.persisted?).to be true
      expect(subject.user.name).to eq "Student"
      expect(subject.user.client_account).not_to be nil
      expect(subject.user.client_account.student_accounts.any?).to be true
      expect(subject.user.student_account).not_to be nil
      expect(subject.user.is_student?).to be true
    end
  end
end
