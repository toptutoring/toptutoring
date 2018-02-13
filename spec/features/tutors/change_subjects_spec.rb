require 'rails_helper'

feature "Tutors change subjects" do
  let(:tutor) { FactoryBot.create(:tutor_user) }

  before(:each) do
    FactoryBot.create(:subject, name: "Math")
    FactoryBot.create(:subject, name: "English")
    FactoryBot.create(:subject, name: "Science")
  end

  scenario "when viewing subjects" do
    sign_in tutor

    visit tutors_subjects_path

    expect(tutor.tutor_account.subjects.count).to be 0
    expect(page).to have_content("Your Subjects")
    Subject.all.each do |tutor_subject|
      expect(page).to have_content(tutor_subject.name)
    end

    check("Math")
    click_button("Submit")

    expect(page).to have_content(I18n.t("app.tutors.subjects.update_success"))
    expect(tutor.reload.tutor_account.subjects.count).to be 1
  end
end
