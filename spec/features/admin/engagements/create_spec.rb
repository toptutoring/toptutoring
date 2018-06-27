require 'rails_helper'
require "chosen-rails/rspec"

feature "Index engagements" do
  let(:admin) { User.admin }
  let!(:new_subject) { FactoryBot.create(:subject) }
  let!(:student) { FactoryBot.create(:student_user) }

  context "when admin creates an engagement" do
    scenario "with valid parameters", js: true do
      sign_in(admin)
      visit engagements_path
      click_on "Add a new engagement"

      chosen_select new_subject.name, from: "engagement_subject_id"
      chosen_select student.full_name, from: "engagement_student_account_id"
      click_on "Submit"

      engagement = Engagement.last
      expect(page).to have_content "Engagement successfully created!"
      expect(Engagement.count).to eq 1
      expect(engagement.student_account_id).to eq student.student_account.id
      expect(engagement.client_account_id).to eq student.client.client_account.id
      expect(engagement.tutor_account).to eq nil
    end
  end
end
