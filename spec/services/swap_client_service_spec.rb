require "rails_helper"

describe SwapClientService do
  describe ".swap!" do
    let(:client) { FactoryBot.create(:client_user) }
    let(:student) { FactoryBot.create(:student_user, first_name: "BobStudent", client: client) }

    context "for a Client without students" do
      it "converts the Client into a Student-Client" do
        Engagement.destroy_all
        client.switch_to_student = "1"
        client.create_student_account(
          name: client.full_name,
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

    context "for client with no engagements and no students" do
      it "makes a Client into a Student-Client" do
        client.switch_to_student = "1"
        client.save
        subject = SwapClientService.new(client, nil)
        results = subject.swap!

        expect(client.client_account.student_accounts.count).to be 1
      end
    end
  end
end
