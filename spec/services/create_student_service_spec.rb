require "rails_helper"

describe CreateStudentService do
  describe "#process!" do
    let(:client) { FactoryBot.create(:client_user) }
    let(:first_name) { "StudentName" }
    let(:last_name) { "StudentLastName" }
    let(:full_name) { "#{first_name} #{last_name}" }
    let(:engagement_subject) { FactoryBot.create(:subject) }
    let(:student_params)  {
      { first_name: first_name,
        last_name: last_name,
        email: "student@example.com",
        phone_number: client.phone_number,
        password: "PassWord",
        roles: Role.where(name: "student"),
        client_id: client.id }
    }

    it "creates a student account and user for client" do
      subject = CreateStudentService.new(client)
      student_account_count = StudentAccount.count
      results = subject.process!(full_name, engagement_subject, student_params)

      new_student_account = StudentAccount.last
      new_user = User.last

      expect(results.success?).to be true
      expect(results.messages).to eq I18n.t("app.add_student.success")
      expect(StudentAccount.count).to eq student_account_count + 1
      expect(new_student_account.client).to eq client
      expect(new_student_account.name).to eq new_user.full_name
    end

    it "creates a user associated with the account" do
      subject = CreateStudentService.new(client)
      user_count = User.count
      subject.process!(full_name, engagement_subject, student_params)

      new_student_account = StudentAccount.last
      new_user = User.last

      expect(User.count).to eq user_count + 1
      expect(new_student_account.user).to eq new_user
    end

    it "creates an engagement associated with the client and student" do
      subject = CreateStudentService.new(client)
      engagement_count = Engagement.count
      subject.process!(full_name, engagement_subject, student_params)

      new_student_account = StudentAccount.last
      new_engagement = Engagement.last

      expect(Engagement.count).to eq engagement_count + 1
      expect(new_engagement.client_account).to eq client.client_account
      expect(new_engagement.student_account).to eq new_student_account
    end

    it "creates a student account and no user if params aren't sent" do
      subject = CreateStudentService.new(client)
      student_account_count = StudentAccount.count
      results = subject.process!(full_name, engagement_subject)

      new_student_account = StudentAccount.last
      new_engagement = Engagement.last

      expect(results.success?).to be true
      expect(results.messages).to eq I18n.t("app.add_student.success")
      expect(new_student_account.client).to eq client
      expect(new_student_account.user).to be nil
      expect(new_student_account.name).to eq full_name
    end
  end
end
