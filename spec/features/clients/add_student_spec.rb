require "rails_helper"

feature "Add student" do
  let!(:subject) { FactoryBot.create(:subject) }
  let(:existing_client) { FactoryBot.create(:client_user) }
  let(:client) { FactoryBot.create(:client_user) }

  scenario "successfully when client does not provide email" do
    sign_in(client)
    visit new_clients_student_path

    expect(page).to have_content("New Student")

    first_name = "Student"
    last_name = "LastName"
    fill_in "first_name", with: first_name
    fill_in "last_name", with: last_name
    uncheck "create_user_account"
    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content("Successfully added!")
    expect(page).to have_content(first_name)
    expect(page).to have_content(last_name)
  end

  scenario "successfully when client provides email" do
    sign_in(client)
    visit new_clients_student_path

    first_name = "Student"
    last_name = "LastName"
    email = "new_student@example.com"
    fill_in "first_name", with: first_name
    fill_in "last_name", with: last_name
    fill_in "user_email", with: email
    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content("Successfully added!")
    expect(User.where(email: email).any?).to be true
    expect(page).to have_content(first_name)
    expect(page).to have_content(last_name)
  end

  scenario "unsuccessfully when client provides email that already exists" do
    sign_in(client)
    visit new_clients_student_path

    email = existing_client.email
    fill_in "first_name", with: "Student"
    fill_in "last_name", with: "LastName"
    fill_in "user_email", with: email
    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content("Email has already been taken")
  end
end
