require "rails_helper"

feature "Clients Invoices Index" do
  let(:tutor) { FactoryGirl.create(:tutor_user) }
  let(:client) { FactoryGirl.create(:client_user) }
  let(:student_account) { FactoryGirl.create(:student_account, client_account: client.client_account) }
  let(:engagement) { FactoryGirl.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account) }
  let!(:invoice) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, hours: 1, status: "paid") }
  let!(:invoice2) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, hours: 2, status: "pending") }
  let!(:invoice3) { FactoryGirl.create(:invoice, submitter: tutor, client: client, engagement: engagement, hours: 3, status: "denied") }

  scenario "when client visits the invoice index page" do
    sign_in(client)
    visit clients_invoices_path

    expect(page).to have_content("Invoices")
    expect(page).to have_content("Tutor")
    expect(page).to have_content("Student")
    expect(page).to have_content("Subject")
    expect(page).to have_content("Academic Type")
    expect(page).to have_content("Date")
    expect(page).to have_content("Hours")

    expect(page).to have_content(invoice.engagement.student.name)
    expect(page).to have_content(invoice.engagement.subject.name)
    expect(page).to have_content(invoice.engagement.academic_type.humanize)
    expect(page).to have_content(l(invoice.created_at, format: :short))
    expect(page).to have_content(invoice.hours)
    expect(page).to have_content(invoice2.hours)
    expect(page).not_to have_content(invoice3.hours)
  end
end
