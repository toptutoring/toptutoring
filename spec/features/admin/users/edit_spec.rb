require 'spec_helper'

feature "Edit user" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:student) { FactoryGirl.create(:student_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:director) { FactoryGirl.create(:director_user) }

  scenario "is submitted successfully" do
    sign_in(admin)

    visit edit_admin_user_path(student)

    fill_in "Name", with: "Jack"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Jack".humanize)

    visit edit_admin_user_path(tutor)

    fill_in "Name", with: "Todd"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Todd".humanize)

    visit edit_admin_user_path(client)

    fill_in "Name", with: "Brian"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Brian".humanize)

    visit edit_admin_user_path(director)

    fill_in "Name", with: "Pierre"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Pierre".humanize)
  end
end
