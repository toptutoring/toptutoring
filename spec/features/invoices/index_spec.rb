require "rails_helper"

feature "Invoices Index" do
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let(:student_account) { FactoryBot.create(:student_account, client_account: client.client_account) }
  let(:engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, student_account: student_account, client_account: client.client_account) }
  let!(:invoice) { FactoryBot.create(:invoice, submitter: tutor, client: client, engagement: engagement) }

  scenario "when user is tutor" do
    sign_in(tutor)
    visit tutors_invoices_path

    expect(page).to have_content("Invoices")
    expect(page).to have_content("Client")
    expect(page).to have_content("Subject")
    expect(page).to have_content("Academic Type")
    expect(page).to have_content("Date")
    expect(page).to have_content("Description")
    expect(page).to have_content("Hours")

    expect(page).to have_content(invoice.engagement.client.full_name)
    expect(page).to have_content(invoice.engagement.subject.name)
    expect(page).to have_content(invoice.engagement.academic_type.humanize)
    expect(page).to have_content(invoice.created_at)
    expect(page).to have_content(invoice.description)
    expect(page).to have_content(invoice.hours)
    end
end
