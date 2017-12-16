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

      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.created_at.strftime("%B %e, %Y"))
      expect(page).to have_content("Your Subjects")
      expect(page).to have_content("Dwolla:")
    end

    scenario "and edits profile" do
      sign_in(tutor)
      visit edit_profile_path

      expect(page).to have_content("Profile")
      expect(page).to have_content(tutor.name)

      name = "New Name"
      fill_in "user_name", with: name

      click_button "Submit"
      
      expect(page).to have_content("Your profile has been updated.")
      expect(page).to have_content(name)
      expect(tutor.reload.name).to eq(name)
    end
  end

  context "when user is a client" do
    scenario "and visits profile page" do
      sign_in(client)
      visit profile_path

      expect(page).to have_content(client.name)
      expect(page).to have_content(client.email)
      expect(page).to have_content(client.created_at.strftime("%B %e, %Y"))
    end

    scenario "and edits profile" do
      sign_in(client)
      visit edit_profile_path

      expect(page).to have_content("Profile")
      expect(page).to have_content(client.name)

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

      expect(page).to have_content(student.name)
      expect(page).to have_content(student.email)
      expect(page).to have_content(student.created_at.strftime("%B %e, %Y"))
    end
  end
end
