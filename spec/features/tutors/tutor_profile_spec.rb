require 'rails_helper'

feature "Tutors are able to update their profiles", js: true  do
  let(:tutor) { FactoryBot.create(:tutor_user) }

  before(:each) do
    FactoryBot.create(:subject, name: "SAT", academic_type: "test_prep")
    FactoryBot.create(:subject, name: "ACT", academic_type: "test_prep")
    FactoryBot.create(:subject, name: "Science")
  end

  scenario "when adding a score" do
    sign_in tutor
    visit tutors_tutor_profile_path

    expect(page).to have_css("option", text: "SAT")
    expect(page).to have_css("option", text: "ACT")
    expect(page).not_to have_css("option", text: "Science")
    select("SAT", from: "Test")
    score = "1600"
    fill_in "Score", with: score
    click_button "Add"

    expect(page).to have_content("Your score has been recorded.")
    expect(TestScore.last.score).to eq score
    expect(TestScore.last.tutor_account).to eq tutor.tutor_account
  end

  scenario "when removing a score" do
    sign_in tutor
    score = FactoryBot.create(:test_score, tutor_account: tutor.tutor_account, subject: Subject.first)
    visit tutors_tutor_profile_path

    expect(page).to have_content(score.subject.name)
    expect(page).not_to have_css("option", text: score.subject.name)
    expect(page).to have_link("Remove", href: tutors_test_score_path(score))
    click_link "Remove"
    expect(page).to have_content("Your score has been removed.")
    expect(page).to have_css("option", text: score.subject.name)
    expect(page).not_to have_link("Remove", href: tutors_test_score_path(score))
    expect(TestScore.count).to eq 0
  end

  scenario "when updating descriptions" do
    sign_in tutor
    visit tutors_tutor_profile_path

    desc = "A description"
    long_desc = "A long description"
    fill_in "tutor_account[short_description]", with: desc
    fill_in "tutor_account[description]", with: long_desc
    click_on "Submit"

    expect(page).to have_content("Your public profile has been updated.")
    expect(tutor.reload.tutor_account.short_description).to eq desc
    expect(tutor.reload.tutor_account.description).to eq long_desc
  end

  scenario "when adding profile info, tutor is only published when admin allows" do
    account = tutor.tutor_account
    account.update(description: "A description", short_description: "A short description")
    unset_subdomain
    visit pages_tutors_path
    expect(page).not_to have_content(account.user.first_name)
    expect(page).not_to have_content(account.user.last_name)
    expect(page).not_to have_content(account.description)
    expect(page).not_to have_content(account.short_description)

    account.update(publish: true)

    visit pages_tutor_path(tutor.first_name)
    expect(page).to have_content(account.user.first_name)
    expect(page).not_to have_content(account.user.last_name)
    expect(page).to have_content(account.description)
    expect(page).not_to have_content(account.short_description)
    set_subdomain("app")
  end
end
