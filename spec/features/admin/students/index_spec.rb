require 'spec_helper'

feature "Index students" do
  context "when user is director or admin" do
    scenario "should see students" do
      admin = FactoryGirl.create(:admin_user)
      director = FactoryGirl.create(:director_user)
      student = FactoryGirl.create(:student_user)
      student.assignment.update(tutor_id: director.id)

      [admin, director].each do |user|
        sign_in(user)
        visit tutors_students_path
        expect(page).to have_content("Name")
        expect(page).to have_content("Parent")
        expect(page).to have_content("Email")
        expect(page).to have_content("Phone Number")
        expect(page).to have_content("Subject")
        expect(page).to have_content("Academic Type")
        expect(page).to have_content("Balance")
        expect(page).to have_content(student.name)
        expect(page).to have_content(student.parent.name)
        expect(page).to have_content(student.email)
        expect(page).to have_content(student.phone_number)
        expect(page).to have_content(student.student_info.subject)
        expect(page).to have_content(student.student_info.academic_type)
        expect(page).to have_content(student.parent.balance)
      end
    end
  end
end
