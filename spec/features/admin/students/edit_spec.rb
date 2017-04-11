require 'spec_helper'

feature "Edit student" do
  scenario "has valid form" do
    admin = FactoryGirl.create(:admin_user)
    student = FactoryGirl.create(:student_user)

    sign_in(admin)
    visit edit_admin_user_path(student)

    expect(page).to have_field "user_student_info_attributes_subject", with: student.student_info.subject
  end

  scenario "is submitted successfully" do
    admin = FactoryGirl.create(:admin_user)
    student = FactoryGirl.create(:student_user)
    tutor = FactoryGirl.create(:tutor_user)
    student.assignment.update(tutor_id: tutor.id)

    sign_in(admin)
    visit edit_admin_user_path(student)

    fill_in "user_student_info_attributes_subject", with: "Biology"
    click_on "Submit"
    expect(page).to have_content("User successfully updated!")
  end
end
