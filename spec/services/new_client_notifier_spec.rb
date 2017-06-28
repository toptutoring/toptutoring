require "rails_helper"

describe NewClientNotifier do
  let(:director) { build_stubbed(:director_user) }
  let(:admin) { build_stubbed(:admin_user) }
  let(:client) { build_stubbed(:client_user) }
  let (:notifier) { NewClientNotifier }

  it "doesn't notify anyone" do
    expect { notifier.perform(client, []) }
      .to change { ActionMailer::Base.deliveries.count }.by(0)
  end

  it "notifies director and admin" do
    expect { notifier.perform(client, [director, admin]) }
      .to change { ActionMailer::Base.deliveries.count }.by(2)
  end
end
