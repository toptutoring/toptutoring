require 'spec_helper'

feature "Index tutors" do
  before(:all) do
    set_roles
  end
  context "when user is director" do
    scenario "should see tutors" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(director)
      visit admin_tutors_path

      expect(page).to have_content("Tutors")
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Balance")
      expect(page).to have_content("Hourly Rate")
      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.tutor_info.subject)
      expect(page).to have_content(tutor.tutor_info.academic_type)
      expect(page).to have_content("#{tutor.balance} hrs of tutoring")
      expect(page).to have_content(tutor.tutor_info.hourly_rate)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Pay tutor")
    end
  end

  context "when user is admin" do
    scenario "should see tutors" do
      admin = FactoryGirl.create(:admin_user)
      tutor = FactoryGirl.create(:tutor_user)

      sign_in(admin)
      visit admin_tutors_path

      expect(page).to have_content("Tutors")
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Balance")
      expect(page).to have_content("Hourly Rate")
      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.tutor_info.subject)
      expect(page).to have_content(tutor.tutor_info.academic_type)
      expect(page).to have_content("#{tutor.balance} hrs of tutoring")
      expect(page).to have_content(tutor.tutor_info.hourly_rate)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Pay tutor")
    end
  end
end
