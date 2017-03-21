require 'spec_helper'

feature "Edit tutor" do
  context "when user is director" do
    scenario "has valid form" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic type")
      expect(page).to have_content("Hourly rate")
      expect(page).to have_field "user_tutor_info_attributes_subject", with: tutor.tutor_info.subject
      expect(page).to have_field "user_tutor_info_attributes_academic_type", with: tutor.tutor_info.academic_type
      expect(page).to have_field "user_tutor_info_attributes_hourly_rate", with: tutor.tutor_info.hourly_rate
    end

    scenario "with invalid params" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      fill_in "user_tutor_info_attributes_academic_type", with: nil
      click_on "Submit"
      expect(page).to have_content("Tutor info academic type can't be blank")
    end

    scenario "with valid params" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      fill_in "user_tutor_info_attributes_subject", with: "Literature"
      click_on "Submit"
      expect(page).to have_content("Tutor successfully updated!")
    end
  end

  context "when user is admin" do
    scenario "with invalid params" do
      admin = FactoryGirl.create(:admin_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(admin)
      visit edit_admin_tutor_path(tutor)

      fill_in "user_tutor_info_attributes_academic_type", with: nil
      click_on "Submit"
      expect(page).to have_content("Tutor info academic type can't be blank")
    end

    scenario "with valid params" do
      admin = FactoryGirl.create(:admin_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(admin)
      visit edit_admin_tutor_path(tutor)

      fill_in "user_tutor_info_attributes_subject", with: "Literature"
      click_on "Submit"
      expect(page).to have_content("Tutor successfully updated!")
    end
  end
end
