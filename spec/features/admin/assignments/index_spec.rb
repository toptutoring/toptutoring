require 'spec_helper'

feature "Index assignments" do
  before(:all) do
    set_roles
  end
  context "when user is director" do
    scenario "should see assignments" do
      director = FactoryGirl.create(:director_user)
      tutor = FactoryGirl.create(:tutor_user)
      student = FactoryGirl.create(:student_user)
      assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)

      sign_in(director)
      visit assignments_path
      expect(page).to have_content("Assignments")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Hourly Rate")
      expect(page).to have_content("Status")
      expect(page).to have_content(assignment.id)
      expect(page).to have_content(assignment.student.name)
      expect(page).to have_content(assignment.subject)
      expect(page).to have_content(assignment.academic_type)
      expect(page).to have_content(assignment.hourly_rate)
      expect(page).to have_content(assignment.state)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Disable")
    end
  end

  context "when user is admin" do
    scenario "should see assignments" do
      admin = FactoryGirl.create(:admin_user)
      tutor = FactoryGirl.create(:tutor_user)
      student = FactoryGirl.create(:student_user)
      assignment = FactoryGirl.create(:assignment, tutor: tutor, student: student)

      sign_in(admin)
      visit assignments_path
      expect(page).to have_content("Assignments")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Hourly Rate")
      expect(page).to have_content("Status")
      expect(page).to have_content(assignment.id)
      expect(page).to have_content(assignment.student.name)
      expect(page).to have_content(assignment.subject)
      expect(page).to have_content(assignment.academic_type)
      expect(page).to have_content(assignment.hourly_rate)
      expect(page).to have_content(assignment.state)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Disable")
    end
  end
end
