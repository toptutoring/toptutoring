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

    click_link("archive_user_link_#{client.id}")
    click_link("confirm-modal-link")

    expect(page).to have_content "#{client.full_name} has been archived"
    expect(engagement.reload.state).to eq "archived"
    expect(tutor_engagement.reload.state).to eq "archived"
    expect(client.reload.archived).to eq true

    within("#row_user_#{client.id}") { find_link("Reactivate").click }
    click_link("confirm-modal-link")

    expect(page).to have_link("archive_user_link_#{client.id}")
    expect(engagement.reload.state).to eq "archived"
    expect(tutor_engagement.reload.state).to eq "archived"
    expect(client.reload.archived).to eq false
  end

  scenario "archives only engagements associated with user", js: true do
    sign_in(admin)

    visit admin_users_path

    click_link("archive_user_link_#{tutor.id}")
    click_link("confirm-modal-link")

    expect(find("#row_user_#{tutor.id}")).to have_link("Reactivate")
    expect(engagement.reload.state).to eq "active"
    expect(tutor_engagement.reload.state).to eq "archived"
    expect(tutor.reload.archived).to eq true
  end
end
