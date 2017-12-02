require "rails_helper"

feature "Passwords can be reset" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:student_account) { FactoryGirl.create(:student_account, user: student, client_account: client.client_account) }

  scenario "when reset link with token is sent to user" do
    student_account
    student.update(password: "first", confirmation_token: "test")
    visit edit_password_path(user_id: student.id, token: "test")

    expect(page).to have_content("Change your password")

    fill_in "password_reset_password", with: "newpassword"
    click_button "Save this password"

    expect(page).to have_content(student.name)
  end

  scenario "by generating token through reset password path" do
    expect(client.confirmation_token).to be nil
    visit reset_password_path

    expect(page).to have_content("Reset your password")

    fill_in "password_email", with: client.email
    click_button "Send Instructions"

    expect(client.reload.confirmation_token).not_to be nil
  end
end
