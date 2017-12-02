require "rails_helper"

describe AdminDirectorNotifierMailer do
  let!(:admin) { FactoryGirl.create(:admin_user) }
  let!(:director) { FactoryGirl.create(:director_user) }
  let(:client) { build_stubbed(:client_user) }
  let (:email) { AdminDirectorNotifierMailer.new_user_started_sign_up(client) }

  it "delivers an notification email" do
    email.deliver_now
    expect(email.bcc).to include(admin.email, director.email)
    expect(email.from).to eq(["tutor@toptutoring.com"])
    expect(email.subject).to eq("#{client.name} has begun the signup process as a client")
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
