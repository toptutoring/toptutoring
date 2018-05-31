require 'rails_helper'

feature "Edit tutor" do
  let(:admin) { User.admin }
  let(:director) { FactoryBot.create(:director_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }

  context "when user is director" do
    scenario "has valid form" do
      tutor
      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_selector("input[value='#{tutor.first_name}']")
      expect(page).to have_selector("input[value='#{tutor.last_name}']")
      expect(page).to have_selector("input[value='#{tutor.email}']")
    end

    scenario "with invalid params" do
      tutor
      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      fill_in "Email", with: nil
      click_on "Submit"

      expect(page).to have_content("Email can't be blank")
    end

    scenario "with valid params" do
      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      fill_in "user_first_name", with: "new tutor"
      fill_in "Email", with: "new_email@gmail.com"

      click_on "Submit"

      expect(page).to have_content("Tutor successfully updated!")
    end
  end

  context "when user is admin" do
    scenario "with invalid params" do
      sign_in(admin)
      visit edit_admin_tutor_path(tutor)

      fill_in "Email", with: nil
      click_on "Submit"

      expect(page).to have_content("Email can't be blank")
    end

    scenario "with valid params" do
      sign_in(admin)
      visit edit_admin_tutor_path(tutor)

      fill_in "user_first_name", with: "new tutor"
      fill_in "Email", with: "new_email@gmail.com"

      click_on "Submit"

      expect(page).to have_content("Tutor successfully updated!")
    end
  end
end
