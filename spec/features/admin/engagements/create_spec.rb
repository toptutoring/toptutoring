require 'rails_helper'

feature "Index engagements" do
  let(:admin) { User.admin }
  let!(:student) { FactoryBot.create(:student_user) }

  context "when admin creates an engagement" do
    scenario "with valid parameters" do
      FactoryBot.create(:subject)
      sign_in(admin)
      visit engagements_path
      click_on "Add a new engagement"

      find("#engagement_subject_id").find(:xpath, "option[2]").select_option
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
