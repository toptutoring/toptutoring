require 'rails_helper'

feature "Editing tutor profiles", js: true do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }

  before :each do 
    FactoryBot.create(:test_score, tutor_account: tutor.tutor_account)
    FactoryBot.create(:test_score, tutor_account: tutor.tutor_account)
    tutor.tutor_account.update(description: "A description about the tutor",
                               short_description: "A short description")
  end

  context "when user is director" do
    scenario "adding badge to scores" do
      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      tutor.tutor_account.test_scores.each do |score|
        expect(page).to have_content(score.subject.name)
        expect(page).to have_content(score.score)
        expect(page).to have_link("Add Badge",
                                  href: admin_tutor_account_badge_path(tutor.tutor_account, badge_id: score))
      end
      expect(page).to have_content(tutor.tutor_account.description)
      expect(page).to have_content(tutor.tutor_account.short_description)

      score = TestScore.first
      find_link("Add Badge", href: admin_tutor_account_badge_path(tutor.tutor_account, badge_id: score)).click
      expect(page).to have_link("Remove Badge", href: admin_tutor_account_badge_path(tutor.tutor_account, badge_id: score))
      expect(page).to have_content("Badge has been added.")
      expect(score.reload.badge).to be_truthy
      find_link("Remove Badge", href: admin_tutor_account_badge_path(tutor.tutor_account, badge_id: score)).click
      expect(page).to have_link("Add Badge", href: admin_tutor_account_badge_path(tutor.tutor_account, badge_id: score))
      expect(score.reload.badge).to be_falsey
    end

    scenario "publishing a tutor's profile" do
      account = tutor.tutor_account
      unset_subdomain
      visit pages_tutors_path
      expect(page).not_to have_content(account.user.first_name.upcase)
      expect(page).not_to have_content(account.user.last_name)
      expect(page).not_to have_content(account.description)
      expect(page).not_to have_content(account.short_description)

      set_subdomain("app")
      sign_in(director)
      visit edit_admin_tutor_path(tutor)

      click_link("Publish")
      expect(page).to have_content("Updated tutor's profile")
      expect(page).to have_link("Unpublish")
      
      unset_subdomain
      visit pages_tutors_path
      expect(page).to have_content(account.user.first_name.upcase)
      expect(page).not_to have_content(account.user.last_name)
      expect(page).not_to have_content(account.description)
      expect(page).to have_content(account.short_description)

      visit pages_tutor_path(tutor.first_name)
      expect(page).to have_content(account.user.first_name)
      expect(page).not_to have_content(account.user.last_name)
      expect(page).to have_content(account.description)
      expect(page).not_to have_content(account.short_description)
      set_subdomain("app")
    end
  end

  context "when user is admin" do
    scenario "and visits tutor profile page" do
      sign_in(admin)
      visit edit_admin_tutor_path(tutor)

      tutor.tutor_account.test_scores.each do |score|
        expect(page).to have_content(score.subject.name)
        expect(page).to have_content(score.score)
        expect(page).to have_link("Add Badge",
                                  href: admin_tutor_account_badge_path(tutor.tutor_account, badge_id: score))
      end
      expect(page).to have_content(tutor.tutor_account.description)
      expect(page).to have_content(tutor.tutor_account.short_description)
      expect(page).to have_link("Publish")
    end
  end
end
