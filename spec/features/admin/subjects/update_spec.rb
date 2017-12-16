require 'rails_helper'

feature 'Subjects Index' do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:subject_academic) { FactoryBot.create(:subject) }
  let(:subject_test_prep) { FactoryBot.create(:subject, academic_type: 'test_prep') }

  scenario 'when tutoring type is changed from Academic to Test Prep' do
    subject_academic
    sign_in(admin)
    visit admin_subjects_path
    click_on "Switch to Test Prep"

    expect(page).to have_content("Tutoring Type has been changed to Test Prep for #{subject_academic.name}.")
    expect(page).to have_selector("div", class: "btn btn-success", text: "Test Prep")
    expect(page).to have_selector("a", class: "btn btn-outline btn-primary", text: "Switch to Academic")
  end

  scenario 'when tutoring type is changed from Test Prep to Academic' do
    subject_test_prep
    sign_in(admin)
    visit admin_subjects_path
    click_on "Switch to Academic"

    expect(page).to have_content("Tutoring Type has been changed to Academic for #{subject_test_prep.name}.")
    expect(page).to have_selector("div", class: "btn btn-primary", text: "Academic")
    expect(page).to have_selector("a", class: "btn btn-outline btn-success", text: "Switch to Test Prep")
  end
end
