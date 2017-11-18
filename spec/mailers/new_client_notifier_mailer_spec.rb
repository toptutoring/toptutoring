require "rails_helper"

describe NewClientNotifierMailer do
  let(:director) { build_stubbed(:director_user) }
  let(:client) { build_stubbed(:client_user) }
  let (:email) { NewClientNotifierMailer.started_sign_up(client) }

  it "delivers an notification email" do
    expect(email.to).to eq([director.email])
    expect(email.from).to eq(["tutor@toptutoring.com"])
    expect(email.subject).to eq("#{client.name} has just registered")
  end
end
