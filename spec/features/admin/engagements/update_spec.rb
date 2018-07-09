require "rails_helper"
require "chosen-rails/rspec"

feature "Update engagements" do
  let(:admin) { User.admin }
  let(:director) { FactoryBot.create(:director_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: nil, student_account: student_account, client_account: client.client_account, state: "pending") }
  let!(:tutor) { FactoryBot.create(:tutor_user, first_name: "AmazingTutor") }

  context "when user is director" do
    scenario "updating a tutor for a pending engagement", js: true do
      sign_in(director)

      expect(page).to have_content("Pending Engagements")
      expect(page).to have_link(href: edit_engagement_path(engagement))
      expect(page).not_to have_link( href: enable_engagement_path(engagement))

      click_link("edit_engagement_link_#{engagement.id}")

      expect(page).to have_content("Tutor")
      expect(page).to have_content("Student")
      expect(page).to have_content("Client")

      chosen_select tutor.full_name, from: "engagement_tutor_account_id"
      click_button "Submit"

      expect(page).to have_content("Engagement successfully updated!")
      expect(page).to have_content(student_account.name)
      expect(page).to have_content(tutor.full_name)

      click_link("enable_engagement_link_#{engagement.id}")
      click_link("confirm-modal-link")

      expect(page).to have_content("Engagement successfully enabled!")

      click_link("archive_engagement_link_#{engagement.id}")
      click_link("confirm-modal-link")

      expect(page).to have_content("Engagement successfully disabled and archived!")
    end
  end
end
