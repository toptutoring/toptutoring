require "rails_helper"

feature "Update engagements" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: nil, student_account: student_account, client_account: client.client_account, state: "pending") }
  let!(:tutor) { FactoryBot.create(:tutor_user, name: "Amazing Tutor") }

  context "when user is director" do
    scenario "updating a tutor for a pending engagement" do
      sign_in(director)

      expect(page).to have_content("Pending Engagements")
      expect(page).to have_link("Edit")
      expect(page).not_to have_link("Enable")

      click_link "Edit"

      expect(page).to have_content("Tutor")
      expect(page).to have_content("Student")
      expect(page).to have_content("Client")

      find("#engagement_tutor_account_id").find(:xpath, "option[2]").select_option
      click_button "Submit"

      expect(page).to have_content("Engagement successfully updated!")
      expect(page).to have_content("Student")
      expect(page).to have_content(tutor.name)
    end

    scenario "when enabling and disabling an engagement" do
      engagement.update(tutor_account: tutor.tutor_account)
      sign_in(director)
      visit engagements_path

      click_link "Enable"
      expect(page).to have_content("Engagement successfully enabled!")

      click_link "Disable"
      expect(page).to have_content("Engagement successfully disabled!")
    end

    scenario "updating the student for the engagement" do
      sign_in(director)
      client.client_account.student_accounts << FactoryBot.create(:student_account)
      
      visit edit_engagement_path(engagement)
      find("#engagement_student_account_id").find(:xpath, "option[2]").select_option

      click_on "Submit"
      expect(page).to have_content("Engagement successfully updated!")
    end
  end
end
