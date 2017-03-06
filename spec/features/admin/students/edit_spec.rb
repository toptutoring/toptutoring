require 'spec_helper'

feature "Edit student" do
  scenario "has valid form" do
    admin = FactoryGirl.create(:admin_user)
    parent = FactoryGirl.create(:parent_user)

    sign_in(admin)
    visit edit_admin_user_path(parent)

    expect(page).to have_field "user_student_attributes_name", with: parent.student.name
    expect(page).to have_field "user_student_attributes_subject", with: parent.student.subject
    expect(page).to have_field "user_student_attributes_academic_type", with: parent.student.academic_type
    expect(page).to have_field "user_balance", with: parent.balance
  end

  scenario "is submitted successfully" do
    admin = FactoryGirl.create(:admin_user)
    parent = FactoryGirl.create(:parent_user)
    tutor = FactoryGirl.create(:tutor_user)
    parent.assignment.update(tutor_id: tutor.id)

    sign_in(admin)
    visit edit_admin_user_path(parent)

    fill_in "user_balance", with: 200
    click_on "Submit"
    expect(page).to have_content("User successfully updated!")
  end
end
