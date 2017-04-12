require 'spec_helper'

feature "Edit user" do
  scenario "is submitted successfully" do
    admin    = FactoryGirl.create(:admin_user)
    student  = FactoryGirl.create(:student_user)
    tutor    = FactoryGirl.create(:tutor_user)
    client   = FactoryGirl.create(:client_user)
    director = FactoryGirl.create(:director_user)

    sign_in(admin)
    
    visit edit_admin_user_path(student)

    fill_in "Name", with: "Student Jack"
    click_on "Submit"
    visit admin_users_path
    expect(page).to have_content("Student Jack".humanize)

    visit edit_admin_user_path(tutor)
    fill_in "Name", with: "Tutor Jack"
    click_on "Submit"
    visit admin_users_path 
    expect(page).to have_content("Tutor Jack".humanize)

    visit edit_admin_user_path(client)
    fill_in "Name", with: "Client Jack"
    click_on "Submit"
    visit admin_users_path
    expect(page).to have_content("Client Jack".humanize)

    visit edit_admin_user_path(director)
    fill_in "Name", with: "Director Jack"
    click_on "Submit"
    visit admin_users_path 
    expect(page).to have_content("Director Jack".humanize)
  end
end
