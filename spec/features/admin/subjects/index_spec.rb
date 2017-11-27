require 'rails_helper'

feature 'Subjects Index' do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let!(:subject_academic) { FactoryGirl.create(:subject) }
  let!(:subject_test_prep) { FactoryGirl.create(:subject, academic_type: 'test_prep') }

  scenario 'when user is admin' do
    sign_in(admin)
    visit admin_subjects_path

    expect(page).to have_content(subject_academic.name)
    expect(page).to have_selector("div", class: "btn btn-primary", text: "Academic")
    expect(page).to have_selector("a", class: "btn btn-outline btn-success", text: "Switch to Test Prep")
    expect(page).to have_content(subject_test_prep.name)
    expect(page).to have_selector("div", class: "btn btn-success", text: "Test Prep")
    expect(page).to have_selector("a", class: "btn btn-outline btn-primary", text: "Switch to Academic")
  end
end
