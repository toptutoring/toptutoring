require "rails_helper"

feature "Request tutors" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student) { FactoryGirl.create(:student_user, client: client) }
  let(:client_as_student) { FactoryGirl.create(:client_user, :as_student) }


  scenario "successfully when client is not a student" do
    student
    sign_in(client)
    visit new_clients_request_tutor_path(id: student.id)
    
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