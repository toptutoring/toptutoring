require "rails_helper"

feature "Dashboard Index" do
  let(:director) { FactoryBot.create(:director_user) }
  let(:contractor) { FactoryBot.create(:contractor_user) }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:client_student) { FactoryBot.create(:client_user, :as_student) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let(:active_engagement) { FactoryBot.create(:engagement, client_account: client.client_account, tutor_account: tutor.tutor_account, state: "active", student_account: student_account) }
  let(:pending_engagement) { FactoryBot.create(:engagement, client_account: client.client_account, tutor_account: tutor.tutor_account, state: "pending", student_account: student_account) }

  scenario "when user is client" do
    active_engagement

    sign_in(client)

    expect(page).to have_content("Your Tutors")
    expect(page).to have_content("Student")
    expect(page).to have_content(active_engagement.student_name)
    expect(page).to have_content("Subject")
    expect(page).to have_content(active_engagement.subject.name.titlecase)
    expect(page).to have_content("Type")
    expect(page).to have_content(active_engagement.academic_type.humanize)
    expect(page).to have_content("Your Balance")
    expect(page).to have_content(client.online_academic_credit)
    expect(page).to have_content("Request a Tutor")
    expect(page).to have_content("Contact Top Tutoring")
    expect(page).to have_link("Dashboard")
    expect(page).to have_link("Purchase Hours")
    expect(page).to have_link("Your Students")
    expect(page).to have_link("Tutoring History")
  end

  scenario "when user is client who is a student" do
    sign_in(client_student)

    expect(page).not_to have_link("Your Students")
    expect(page).to have_link("Your Tutors")
  end

  scenario "when user is tutor" do
    active_engagement

    sign_in(tutor)

    expect(page).to have_content("Your Students")
    expect(page).to have_content("Student Name")
    expect(page).to have_content("Subject")
    expect(page).to have_content("Status")
    expect(page).to have_content("Credit")
    expect(page).to have_content("Pending Invoices")

    expect(page).to have_content(active_engagement.student_name)
    expect(page).to have_content(active_engagement.subject.name)
    expect(page).to have_content(active_engagement.state)
    expect(page).to have_content(active_engagement.client.online_test_prep_credit)
  end

  scenario "when user is director" do
    pending_engagement

    sign_in(director)

    expect(page).to have_content("Pending Engagements")
    expect(page).to have_content("Student Name")
    expect(page).to have_content("Client Name")
    expect(page).to have_content("Phone Number")
    expect(page).to have_content("Subject")
    expect(page).to have_content("Actions")

    number = Phonelib.parse(client.phone_number, client.country_code)
    expect(page).to have_content(pending_engagement.student_name)
    expect(page).to have_content(pending_engagement.client.full_name)
    expect(page).to have_content(number.national)
    expect(page).to have_content(pending_engagement.subject.name)
    expect(page).to have_link(href: edit_engagement_path(pending_engagement))
  end

  scenario "when user is contractor" do
    sign_in(contractor)

    expect(page).to have_content("Timesheet")
    expect(page).to have_content("Hours")
  end
end
