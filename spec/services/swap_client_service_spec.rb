require "rails_helper"

describe SwapClientService do
  describe ".swap!" do
    let(:client) { FactoryBot.create(:client_user) }
    let(:student) { FactoryBot.create(:student_user, first_name: "BobStudent", client: client) }

    context "for student-clients without and engagement" do
      it "makes a student out of the client" do
        client.switch_to_student = "1"
        client.create_student_account(
          name: 'Bob Student',
          client_account_id: client.client_account.id)
        client.save
        subject = SwapClientService.new(client, nil)
        results = subject.swap!

        expect(client.has_role?("client")).to be_truthy
        expect(client.reload.student_account).to be_nil
        expect(StudentAccount.last.user).to eq(client.students.last)
      end
    end

    context "for clients with an engagement already" do
      let(:engagement) { FactoryBot.create(:engagement,
        tutor_account: nil,
        client_account: client.client_account,
        student_account: student.student_account) }
      it "makes a client into a student and swaps" do
        client.switch_to_student = "1"
        client.save
        subject = SwapClientService.new(client, engagement)
        results = subject.swap!

        expect(client.has_role?("client")).to be_falsey
      end
    end

    context "for clients with one engagement but no students" do
      let(:engagement) { FactoryBot.create(:engagement,
        tutor_account: nil,
        client_account: client.client_account) }
      it "makes a client into a client-student" do
        client.switch_to_student = "1"
        client.save
        subject = SwapClientService.new(client, engagement)
        results = subject.swap!

        expect(client.has_role?("client")).to be_truthy
        expect(client.has_role?("student")).to be_truthy
      end
    end

    context "for students with no engagements and no students" do
      it "makes a client into a student and swaps" do
        client.switch_to_student = "1"
        client.save
        subject = SwapClientService.new(client, nil)
        results = subject.swap!

        expect(client.client_account.student_accounts.count).to be 1
      end
    end
  end
end
