require 'rails_helper'

feature "Index engagements" do
  let(:admin) { User.admin }
  let(:director) { FactoryBot.create(:director_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account, state: "active") }
  let!(:pending_engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account, state: "pending") }
  let!(:archived_engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account, state: "archived") }

  context "when user is director" do
    scenario "should see engagements" do
      sign_in(director)
      visit engagements_path

      expect(page).to have_content("Engagements")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")

      expect(page).to have_content(engagement.student.full_name)
      expect(page).to have_content(engagement.subject.name)
      expect(page).to have_css("tr#engagement_#{engagement.id}")
      expect(page).to have_css("#edit_engagement_link_#{engagement.id}")
      expect(page).to have_css("#archive_engagement_link_#{engagement.id}")
      expect(page).not_to have_css("#enable_engagement_link_#{engagement.id}")
      expect(page).not_to have_css("#archive_engagement_link_#{pending_engagement.id}")
      expect(page).to have_css("#enable_engagement_link_#{pending_engagement.id}")
      expect(page).to have_css("#enable_engagement_link_#{archived_engagement.id}")
    end
  end

  context "when user is admin" do
    scenario "should see engagements" do
      engagement.update(state: "pending")
      sign_in(admin)
      visit engagements_path
      expect(page).to have_content("Engagement")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content(engagement.student.full_name)
      expect(page).to have_content(engagement.subject.name)
      expect(page).to have_css("tr#engagement_#{engagement.id}")
      expect(page).to have_css("#edit_engagement_link_#{engagement.id}")
      expect(page).to have_css("#enable_engagement_link_#{engagement.id}")
      expect(page).not_to have_css("#archive_engagement_link_#{engagement.id}")
      expect(page).not_to have_css("#archive_engagement_link_#{pending_engagement.id}")
      expect(page).to have_css("#enable_engagement_link_#{pending_engagement.id}")
      expect(page).to have_css("#enable_engagement_link_#{archived_engagement.id}")
    end
  end
end
