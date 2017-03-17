require 'spec_helper'

feature "Index students" do
  before(:all) do
    set_roles
  end
  context "when user is director or admin" do
    scenario "should see students" do
      admin = FactoryGirl.create(:admin_user)
      director = FactoryGirl.create(:director_user)
      student = FactoryGirl.create(:student_user)
      student.assignment.update(tutor_id: director.id)

      [admin, director].each do |user|
        sign_in(user)
        visit admin_users_path
        expect(page).to have_content("Name")
        expect(page).to have_content("Parent")
        expect(page).to have_content("Email")
        expect(page).to have_content("Phone Number")
        expect(page).to have_content("Subject")
        expect(page).to have_content("Balance")
        expect(page).to have_content(student.name)
        expect(page).to have_content(student.client&.name)
        expect(page).to have_content(student.email)
        expect(page).to have_content(student.phone_number)
        expect(page).to have_content(student.is_student? ? student.client_info.subject : student.student_info.subject)
        expect(page).to have_content(student.is_student? ? student.balance : student.client.balance)
        sign_out
      end
    end
  end
end
