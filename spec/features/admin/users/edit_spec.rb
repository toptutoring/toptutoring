require "rails_helper"

feature "Edit user" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:student) { FactoryBot.create(:student_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:director) { FactoryBot.create(:director_user) }

  scenario "is submitted successfully" do
    sign_in(admin)

    visit edit_admin_user_path(student)

    fill_in "user_first_name", with: "Jack"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Jack".humanize)

    visit edit_admin_user_path(tutor)

    fill_in "user_first_name", with: "Todd"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Todd".humanize)

    visit edit_admin_user_path(client)

    fill_in "user_first_name", with: "Brian"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Brian".humanize)

    visit edit_admin_user_path(director)

    fill_in "user_first_name", with: "Pierre"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Pierre".humanize)
  end
end
