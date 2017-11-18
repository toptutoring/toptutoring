require 'rails_helper'

feature 'Profile' do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }

  context 'when user is tutor' do
    scenario 'and visits profile page' do
      sign_in(tutor)
      visit profile_path

      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.created_at.strftime("%B %e, %Y"))
      expect(page).to have_content("Subjects Listed")
      expect(page).to have_content("Dwolla:")
    end

    scenario 'and edits profile' do
      sign_in(tutor)
      visit edit_profile_path

      expect(page).to have_content("Profile")
      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.phone_number)

      fill_in "user_name", with: "New Name"

      click_button "Submit"
      
      expect(page).to have_content("Your profile has been updated.")
      expect(tutor.reload.name).to eq("New Name")
    end
  end

  context 'when user is a client' do
    scenario 'and visits profile page' do
      sign_in(client)
      visit profile_path

      expect(page).to have_content(client.name)
      expect(page).to have_content(client.email)
      expect(page).to have_content(client.created_at.strftime("%B %e, %Y"))
      expect(page).to have_content("Tell us your availability!")
    end

    scenario 'and edits profile' do
      sign_in(client)
      visit edit_profile_path

      expect(page).to have_content("Profile")
      expect(page).to have_content(client.name)
      expect(page).to have_content(client.phone_number)

      fill_in "user_phone_number", with: "123456"

      click_button "Submit"
      
      expect(page).to have_content("Your profile has been updated.")
      expect(client.reload.phone_number).to eq("123456")
    end
  end

  context 'when user is a student' do
    scenario 'and visits profile page' do
      sign_in(student)
      visit profile_path

      expect(page).to have_content(student.name)
      expect(page).to have_content(student.email)
      expect(page).to have_content(student.created_at.strftime("%B %e, %Y"))
      expect(page).to have_content("Tell us your availability!")
    end
  end
end