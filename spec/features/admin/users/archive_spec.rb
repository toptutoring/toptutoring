require "rails_helper"

feature "Archive user" do
  let(:admin) { User.admin }
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let(:client) { FactoryBot.create(:client_user) }
  let!(:engagement) { FactoryBot.create(:engagement, tutor_account: nil, client_account: client.client_account, state: "active") }
  let!(:tutor_engagement) { FactoryBot.create(:engagement, tutor_account: tutor.tutor_account, client_account: client.client_account, state: "active") }

  scenario "archives and reactivates user", js: true do
    sign_in(admin)

    visit admin_users_path

    page.accept_confirm do
      find_link(href: archive_admin_user_path(client, view: "users")).click
    end

    expect(page).to have_link("Reactivate", href: reactivate_admin_user_path(client, view: "users"))
    expect(engagement.reload.state).to eq "archived"
    expect(tutor_engagement.reload.state).to eq "archived"
    expect(client.reload.archived).to eq true

    page.accept_confirm do
      find_link("Reactivate", href: reactivate_admin_user_path(client, view: "users")).click
    end

    expect(page).to have_link(href: archive_admin_user_path(client, view: "users"))
    expect(engagement.reload.state).to eq "archived"
    expect(tutor_engagement.reload.state).to eq "archived"
    expect(client.reload.archived).to eq false
  end

  scenario "archives only engagements associated with user", js: true do
    sign_in(admin)

    visit admin_users_path

    page.accept_confirm do
      find_link(href: archive_admin_user_path(tutor, view: "users")).click
    end

    expect(page).to have_link("Reactivate", href: reactivate_admin_user_path(tutor, view: "users"))
    expect(engagement.reload.state).to eq "active"
    expect(tutor_engagement.reload.state).to eq "archived"
    expect(tutor.reload.archived).to eq true
  end
end
