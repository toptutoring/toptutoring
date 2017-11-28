require 'rails_helper'

feature 'Dashboard Index' do
  let(:director) { FactoryGirl.create(:director_user) }
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:student_account) { FactoryGirl.create(:student_account, user: student, client: client) }
  let(:active_engagement) { FactoryGirl.create(:engagement, client: client, tutor: tutor, state: "active", student_account: student_account) }
  let(:active_presenter) { EngagementPresenter.new(active_engagement) }
  let(:pending_engagement) { FactoryGirl.create(:engagement, client: client, tutor: tutor, state: "pending", student_account: student_account) }
  let(:pending_presenter) { EngagementPresenter.new(pending_engagement) }

  scenario 'when user is tutor' do
    active_engagement

    sign_in(tutor)

    expect(page).to have_content('Your clients')
    expect(page).to have_content('Student Name')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Credit')
    expect(page).to have_content('Status')

    expect(page).to have_content(active_engagement.student.name)
    expect(page).to have_content(active_engagement.subject.name)
    expect(page).to have_content(active_engagement.academic_type.humanize)
    expect(page).to have_content(active_engagement.state)
    expect(page).to have_content(active_engagement.client.test_prep_credit)
  end

  scenario 'when user is director' do
    pending_engagement

    sign_in(director)

    expect(page).to have_content('Pending Engagements')
    expect(page).to have_content('Student Name')
    expect(page).to have_content('Client Name')
    expect(page).to have_content('Subject')
    expect(page).to have_content('Academic Type')
    expect(page).to have_content('Status')

    expect(page).to have_content(pending_engagement.student.name)
    expect(page).to have_content(pending_engagement.client.name)
    expect(page).to have_content(pending_engagement.subject.name)
    expect(page).to have_content(pending_presenter.engagement_academic_type)
    expect(page).to have_content(pending_engagement.state)
    expect(page).to have_link("Edit")
  end
end
