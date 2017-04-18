require 'spec_helper'

feature "Index engagements" do
  context "when user is director" do
    scenario "should see engagements" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)
      student = FactoryGirl.create(:student_user)
      engagement = FactoryGirl.create(:engagement, tutor: tutor, student: student)

      sign_in(director)
      visit engagements_path
      expect(page).to have_content("Engagements")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Hourly Rate")
      expect(page).to have_content("Status")
      expect(page).to have_content(engagement.id)
      expect(page).to have_content(engagement.student.name)
      expect(page).to have_content(engagement.subject)
      expect(page).to have_content(engagement.academic_type)
      expect(page).to have_content(engagement.hourly_rate)
      expect(page).to have_content(engagement.state)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Disable")
    end
  end

  context "when user is admin" do
    scenario "should see engagements" do
      admin = FactoryGirl.create(:admin_user)
      tutor = FactoryGirl.create(:tutor_user)
      student = FactoryGirl.create(:student_user)
      engagement = FactoryGirl.create(:engagement, tutor: tutor, student: student)

      sign_in(admin)
      visit engagements_path
      expect(page).to have_content("Engagement")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Hourly Rate")
      expect(page).to have_content("Status")
      expect(page).to have_content(engagement.id)
      expect(page).to have_content(engagement.student.name)
      expect(page).to have_content(engagement.subject)
      expect(page).to have_content(engagement.academic_type)
      expect(page).to have_content(engagement.hourly_rate)
      expect(page).to have_content(engagement.state)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Disable")
    end
  end
end
