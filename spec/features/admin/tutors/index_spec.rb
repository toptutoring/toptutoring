require 'rails_helper'

feature "Index tutors" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:director) { FactoryGirl.create(:director_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user, name: "Someone") }
  let(:tutor2) { FactoryGirl.create(:tutor_user, name: "Another") }
  let(:subject1) { FactoryGirl.create(:subject) }
  let(:subject2) { FactoryGirl.create(:subject) }

  context "when user is director" do
    scenario "should see tutors" do
      tutor
      sign_in(director)
      visit admin_tutors_path

      expect(page).to have_content("Tutors")
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Balance")
      expect(page).to have_content("Action")
      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.outstanding_balance)
      expect(page).to have_content("View All")
      expect(page).to have_link("Edit")
      expect(page).not_to have_link("Pay tutor")
    end
  end

  context "when user is admin" do
    scenario "should see tutors" do
      tutor
      sign_in(admin)
      visit admin_tutors_path

      expect(page).to have_content("Tutors")
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Balance")
      expect(page).to have_content("Action")
      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.outstanding_balance)
      expect(page).to have_content("View All")
      expect(page).to have_link("Edit")
      expect(page).to have_link("Pay tutor")
    end

    scenario "can search tutors by subject", js: true do
      tutor.tutor_account.subjects = [subject1]
      tutor2.tutor_account.subjects = [subject2]
      sign_in(admin)
      visit admin_tutors_path

      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor2.name)

      find("#subject_id").find(:xpath, "option[2]").select_option

      expect(page).to have_content(tutor.name)
      expect(page).not_to have_content(tutor2.name)

      find("#subject_id").find(:xpath, "option[3]").select_option

      expect(page).not_to have_content(tutor.name)
      expect(page).to have_content(tutor2.name)
    end
  end
end
