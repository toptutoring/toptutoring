require 'rails_helper'

feature "Index engagements" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account, state: "active") }
  let(:presenter) { EngagementPresenter.new(engagement) }

  context "when user is director" do
    scenario "should see engagements" do
      sign_in(director)
      visit engagements_path

      expect(page).to have_content("Engagements")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Client")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Client Hourly Rate")
      expect(page).to have_content("Status")

      expect(page).to have_content(engagement.id)
      expect(page).to have_content(engagement.student.full_name)
      expect(page).to have_content(engagement.subject.name)
      expect(page).to have_content(presenter.engagement_academic_type)
      expect(page).to have_content(presenter.hourly_rate)
      expect(page).to have_content(engagement.state)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Disable")
    end
  end

  context "when user is admin" do
    scenario "should see engagements" do
      sign_in(admin)
      visit engagements_path
      expect(page).to have_content("Engagement")
      expect(page).to have_content("#")
      expect(page).to have_content("Student")
      expect(page).to have_content("Client")
      expect(page).to have_content("Tutor")
      expect(page).to have_content("Subject")
      expect(page).to have_content("Academic Type")
      expect(page).to have_content("Client Hourly Rate")
      expect(page).to have_content("Status")
      expect(page).to have_content(engagement.id)
      expect(page).to have_content(engagement.student.full_name)
      expect(page).to have_content(engagement.subject.name)
      expect(page).to have_content(presenter.engagement_academic_type)
      expect(page).to have_content(presenter.hourly_rate)
      expect(page).to have_content(engagement.state)
      expect(page).to have_link("Edit")
      expect(page).to have_link("Disable")
    end
  end
end
