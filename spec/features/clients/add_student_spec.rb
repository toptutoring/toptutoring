require "rails_helper"

feature "Add student" do
  let!(:subject) { FactoryGirl.create(:subject) }
  let(:existing_client) { FactoryGirl.create(:client_user) }
  let(:client) { FactoryGirl.create(:client_user) }

  scenario "successfully when client does not provide email" do
    sign_in(client)
    visit new_clients_student_path

    expect(page).to have_content("New Student")

    name = "New Student"
    fill_in "name", with: name
    uncheck "create_user_account"
    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content("Successfully added!")
    expect(page).to have_content(name)
  end

  scenario "successfully when client provides email" do
    sign_in(client)
    visit new_clients_student_path

    name = "New Student"
    email = "new_student@example.com"
    fill_in "name", with: name
    fill_in "user_email", with: email
    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content("Successfully added!")
    expect(User.where(email: email).any?).to be true
    expect(page).to have_content(name)
  end

  scenario "unsuccessfully when client provides email that already exists" do
    sign_in(client)
    visit new_clients_student_path

    email = existing_client.email
    fill_in "name", with: "New Student"
    fill_in "user_email", with: email
    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content("Email has already been taken")
  end
end
