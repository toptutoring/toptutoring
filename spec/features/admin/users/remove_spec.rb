require "rails_helper"

feature "Remove users" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:student) { FactoryBot.create(:student_user, client: client) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:engagement) { FactoryBot.create(:engagement, tutor_account: nil, client_account: client.client_account, student_account: student.student_account) }

  context "when user is admin", js: true do
    scenario "and removes a user" do
      name = client.full_name
      sign_in(admin)

      expect(User.clients.any?).to be true

      visit admin_users_path
      page.accept_confirm do
        find_link(href: admin_user_path(client)).click
      end

      expect(page).to have_content(t("app.admin.users.remove_user_success", name: name))
      expect(User.clients.any?).to be false
      expect(ClientAccount.any?).to be false
    end

    scenario "deletes associated student_accounts" do
      name = client.full_name
      student
      sign_in(admin)

      expect(User.students.any?).to be true

      visit admin_users_path
      page.accept_confirm do
        find_link(href: admin_user_path(client)).click
      end

      expect(page).to have_content(t("app.admin.users.remove_user_success", name: name))
      expect(User.students.any?).to be false
      expect(StudentAccount.any?).to be false
    end

    scenario "deletes associated engagements" do
      name = client.full_name
      engagement
      sign_in(admin)

      expect(Engagement.any?).to be true

      visit admin_users_path
      page.accept_confirm do
        find_link(href: admin_user_path(client)).click
      end

      expect(page).to have_content(t("app.admin.users.remove_user_success", name: name))
      expect(Engagement.any?).to be false
    end

    scenario "and fails removing a user with an invoiced engagement" do
      name = client.full_name
      engagement
      FactoryBot.create(:invoice, engagement: engagement)
      sign_in(admin)

      visit admin_users_path
      page.accept_confirm do
        find_link(href: admin_user_path(client)).click
      end

      expect(page).to have_content(t("app.admin.users.remove_user_failure", name: name))
      expect(ClientAccount.any?).to be true
      expect(Engagement.any?).to be true
    end

    scenario "and fails removing a user with a payment" do
      name = client.full_name
      engagement
      FactoryBot.create(:payment, :hourly_purchase, payer: client)
      sign_in(admin)

      visit admin_users_path
      page.accept_confirm do
        find_link(href: admin_user_path(client)).click
      end

      expect(page).to have_content(t("app.admin.users.remove_user_failure", name: name))
      expect(ClientAccount.any?).to be true
      expect(Payment.any?).to be true
    end
  end

  context "when user is a director" do
    scenario "and is able to view remove feature" do
      tutor
      sign_in(director)

      visit admin_tutors_path

      expect(page).to have_link(href: archive_admin_tutor_path(tutor, view: "tutor"))
    end
  end
end
