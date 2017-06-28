require "rails_helper"

describe NewClientNotifierMailer do
  let(:director) { build_stubbed(:director_user) }
  let(:client) { build_stubbed(:client_user) }
  let (:email) { NewClientNotifierMailer.welcome(client, director) }

  it "delivers an notification email" do
    expect(email.to).to eq([director.email])
    expect(email.from).to eq(["tutor@toptutoring.org"])
    expect(email.subject).to eq("#{client.name} has just registered")
  end
end
