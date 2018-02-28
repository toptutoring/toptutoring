require "rails_helper"

feature "Profile" do
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student) { FactoryBot.create(:student_user, client: client) }
  let(:student_account) { FactoryBot.create(:student_account, user: student, client_account: client.client_account) }

  context "when user is tutor" do
    scenario "and visits profile page" do
      sign_in(tutor)
      visit profile_path

      expect(page).to have_content(tutor.full_name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(l(tutor.created_at, format: :date))
      expect(page).to have_content("Your Subjects")
      expect(page).to have_content("Dwolla:")
    end

    scenario "and edits profile" do
      sign_in(tutor)
      visit edit_profile_path

      expect(page).to have_content("Profile")
      expect(page).to have_content(tutor.full_name)

      first_name = "NewName"
      last_name = "NewLastName"
      fill_in "user_first_name", with: first_name
      fill_in "user_last_name", with: last_name

      click_button "Submit"
      
      expect(page).to have_content("Your profile has been updated.")
      expect(page).to have_content(first_name)
      expect(page).to have_content(last_name)
      expect(tutor.reload.first_name).to eq(first_name)
      expect(tutor.reload.last_name).to eq(last_name)
    end
  end

  context "when user is a client" do
    scenario "and visits profile page" do
      sign_in(client)
      visit profile_path

      expect(page).to have_content(client.full_name)
      expect(page).to have_content(client.email)
      expect(page).to have_content(l(client.created_at, format: :date))
    end

    scenario "and edits profile" do
      sign_in(client)
      visit edit_profile_path

      expect(page).to have_content("Profile")
      expect(page).to have_content(client.full_name)

      number = "408-555-5555"
      fill_in "user_phone_number", with: number

      click_button "Submit"
     
      expect(page).to have_content("Your profile has been updated.")
      expect(client.reload.phone_number).to eq(number)
    end
  end

  context "when user is a student" do
    scenario "and visits profile page" do
      student_account
      sign_in(student)
      visit profile_path

      expect(page).to have_content(student.full_name)
      expect(page).to have_content(student.email)
      expect(page).to have_content(l(student.created_at, format: :date))
    end
  end
end
