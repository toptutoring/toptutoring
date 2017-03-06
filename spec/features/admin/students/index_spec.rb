require 'spec_helper'

feature "Index students" do
  context "when user is director" do
    scenario "should see students" do
      director = FactoryGirl.create(:director_user)
      parent = FactoryGirl.create(:parent_user)
      parent.assignment.update(tutor_id: director.id)

      sign_in(director)
      visit tutors_students_path
      expect(page).to have_content("Name")
      expect(page).to have_content("Parent")
      expect(page).to have_content("Email")
      expect(page).to have_content("Phone Number")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Balance")
      expect(page).to have_content(parent.student.name)
      expect(page).to have_content(parent.name)
      expect(page).to have_content(parent.student.email)
      expect(page).to have_content(parent.phone_number)
      expect(page).to have_content(parent.student.subject)
      expect(page).to have_content(parent.student.academic_type)
      expect(page).to have_content(parent.balance)
    end
  end

  context "when user is admin" do
    scenario "should see students" do
      admin = FactoryGirl.create(:admin_user)
      parent = FactoryGirl.create(:parent_user)
      director = FactoryGirl.create(:director_user)
      parent.assignment.update(tutor_id: director.id)

      sign_in(admin)
      visit admin_users_path
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Balance")
      expect(page).to have_content("Tutor")
      expect(page).to have_content(parent.student.name)
      expect(page).to have_content(parent.student.email)
      expect(page).to have_content(parent.student.subject)
      expect(page).to have_content(parent.student.academic_type)
      expect(page).to have_content(parent.balance)
      expect(page).to have_content(parent.assignment.tutor.name)
      expect(page).to have_content("Edit")
    end
  end
end
