require "rails_helper"

feature "Request tutors" do
  let(:client) { FactoryBot.create(:client_user) }
  let(:student) { FactoryBot.create(:student_user, client: client) }
  let(:client_as_student) { FactoryBot.create(:client_user, :as_student) }

  scenario "successfully when client is not a student" do
    student
    sign_in(client)
    visit new_clients_request_tutor_path(student_account_id: student.student_account.id)

    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content(I18n.t("app.request_tutor.success"))
  end

  scenario "successfully when client is a student" do
    sign_in(client_as_student)
    visit new_clients_request_tutor_path

    find("#engagement_subject_id").find(:xpath, "option[2]").select_option
    click_on "Submit"

    expect(page).to have_content(I18n.t("app.request_tutor.success"))
  end

  scenario "unsuccessfully when client is a student" do
    sign_in(client_as_student)
    visit new_clients_request_tutor_path

    click_on "Submit"

    expect(page).to have_content(I18n.t("app.request_tutor.failure"))
  end
end
