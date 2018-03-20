require 'rails_helper'

feature "Index engagements" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account, state: "active") }
  let!(:pending_engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account, state: "pending") }


  context "when user is director" do
    scenario "should see engagements" do
      sign_in(director)
      visit engagements_path

      expect(page).to have_content("Engagements")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Client Rate / Credit")
      expect(page).to have_content("Status")

      expect(page).to have_content(engagement.id)
      expect(page).to have_content(engagement.student.full_name)
      expect(page).to have_content(engagement.subject.name)
      expect(page).to have_content(engagement.academic_type.titlecase)
      expect(page).to have_content(client.online_academic_rate)
      expect(page).to have_content(client.in_person_academic_rate)
      expect(page).to have_content(engagement.state)
      expect(page).to have_css("tr#engagement_#{engagement.id}")
      expect(page).to have_link(href: edit_engagement_path(engagement))
      expect(page).to have_link(href: disable_engagement_path(engagement))
      expect(page).to have_no_link(href: enable_engagement_path(engagement))
      expect(page).to have_no_link(href: disable_engagement_path(pending_engagement))
      expect(page).to have_link(href: enable_engagement_path(pending_engagement))
    end
  end

  context "when user is admin" do
    scenario "should see engagements" do
      engagement.update(state: "pending")
      sign_in(admin)
      visit engagements_path
      expect(page).to have_content("Engagement")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Client Rate / Credit")
      expect(page).to have_content("Status")
      expect(page).to have_content(engagement.id)
      expect(page).to have_content(engagement.student.full_name)
      expect(page).to have_content(engagement.subject.name)
      expect(page).to have_content(engagement.academic_type.titlecase)
      expect(page).to have_content(client.online_academic_rate)
      expect(page).to have_content(client.in_person_academic_rate)
      expect(page).to have_content(engagement.state)
      expect(page).to have_css("tr#engagement_#{engagement.id}")
      expect(page).to have_link(href: edit_engagement_path(engagement))
      expect(page).to have_link(href: enable_engagement_path(engagement))
      expect(page).to have_no_link(href: disable_engagement_path(engagement))
      expect(page).to have_no_link(href: disable_engagement_path(pending_engagement))
      expect(page).to have_link(href: enable_engagement_path(pending_engagement))
    end
  end
end
