require 'rails_helper'

feature "Index tutors" do
  let(:admin) { User.admin }
  let(:director) { FactoryBot.create(:director_user) }
  let(:tutor) { FactoryBot.create(:tutor_user, first_name: "Someone") }
  let(:tutor2) { FactoryBot.create(:tutor_user, first_name: "Another") }
  let(:subject1) { FactoryBot.create(:subject) }
  let(:subject2) { FactoryBot.create(:subject) }

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
      expect(page).to have_content(tutor.full_name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.tutor_account.balance_pending)
      expect(page).to have_content("View All")
      expect(page).to have_link(href: edit_admin_tutor_path(tutor))
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
      expect(page).to have_content(tutor.full_name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.tutor_account.balance_pending)
      expect(page).to have_content("View All")
      expect(page).to have_link(href: edit_admin_tutor_path(tutor))
      expect(page).to have_link("Pay tutor")
    end

    scenario "can search tutors by subject", js: true do
      require "chosen-rails/rspec"
      tutor.tutor_account.subjects = [subject1]
      tutor2.tutor_account.subjects = [subject2]
      sign_in(admin)
      visit admin_tutors_path

      expect(page).to have_content(tutor.full_name)
      expect(page).to have_content(tutor2.full_name)

      chosen_select subject1.name, from: "subject_id"

      expect(page).to have_content(tutor.full_name)
      expect(page).not_to have_content(tutor2.full_name)

      chosen_select subject2.name, from: "subject_id"

      expect(page).not_to have_content(tutor.full_name)
      expect(page).to have_content(tutor2.full_name)
    end
  end
end
