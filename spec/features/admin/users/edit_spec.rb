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

    fill_in "user_name", with: "Jack"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Jack".humanize)

    visit edit_admin_user_path(tutor)

    fill_in "user_name", with: "Todd"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Todd".humanize)

    visit edit_admin_user_path(client)

    fill_in "user_name", with: "Brian"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Brian".humanize)

    visit edit_admin_user_path(director)

    fill_in "user_name", with: "Pierre"
    click_on "Submit"

    visit admin_users_path
    expect(page).to have_content("Pierre".humanize)
  end

  scenario "by adding student account" do
    sign_in(admin)

    visit edit_admin_user_path(client)

    fill_in "student_account_name", with: "StudentName"
    click_on "Add"
    
    expect(page).to have_content("A new Student Account has been created for #{client.name}.")
  end

  scenario "by removing a student account" do
    sign_in(admin)
    student = FactoryBot.create(:student_user, client: client)

    visit edit_admin_user_path(client)
    click_on "Remove Account"

    expect(page).to have_content("#{student.name}'s student account has been removed.")
  end

  scenario "fails when attempting to remove a student account with an invoiced_engagement" do
    sign_in(admin)
    student = FactoryBot.create(:student_user, client: client)
    engagement = FactoryBot.create(:engagement, student_account: student.student_account, client_account: client.client_account)
    FactoryBot.create(:invoice, engagement: engagement, client: client)

    visit edit_admin_user_path(client)
    click_on "Remove Account"

    expect(page).to have_content("ForeignKeyViolation")
  end
end
