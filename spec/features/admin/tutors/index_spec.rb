require 'spec_helper'

feature "Index tutors" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:director) { FactoryGirl.create(:director_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user) }

  context "when user is director" do
    scenario "should see tutors" do
      tutor
      sign_in(director)
      visit director_tutors_path

      expect(page).to have_content("Tutors")
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Balance")
      expect(page).to have_content("Action")
      expect(page).to have_content(tutor.name)
      expect(page).to have_content(tutor.email)
      expect(page).to have_content(tutor.outstanding_balance)
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
      expect(page).to have_link("Edit")
      expect(page).to have_link("Pay tutor")
    end
  end
end
