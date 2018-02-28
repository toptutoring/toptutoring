require 'rails_helper'

feature "Update engagements" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: nil, student_account: student_account, client_account: client.client_account, state: "pending") }
  let!(:tutor) { FactoryBot.create(:tutor_user, first_name: "AmazingTutor") }

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
      expect(page).to have_content(tutor.full_name)

      click_link "Enable"
      expect(page).to have_content("Engagement successfully enabled!")

      click_link "Disable"
      expect(page).to have_content("Engagement successfully disabled!")
    end
  end
end
