require "rails_helper"

describe AdminDirectorNotifierMailer do
  let!(:admin) { User.admin }
  let!(:director) { FactoryBot.create(:director_user) }
  let(:client) { build_stubbed(:client_user) }
  let (:email) { AdminDirectorNotifierMailer.new_user_registered(client) }

  it "delivers an notification email" do
    email.deliver_now
    expect(email.bcc).to include(admin.email, director.email)
    expect(email.from).to eq([ENV.fetch("MAILER_SENDER")])
    expect(email.subject).to eq("#{client.full_name} has registered as a client")
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
