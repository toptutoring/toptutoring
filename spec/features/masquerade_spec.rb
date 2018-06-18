require "rails_helper"

feature "Masquerading" do
  let!(:client) { FactoryBot.create(:client_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:admin) { User.admin }

  scenario "when directors masquerade as clients", js: true do
    client
    sign_in(director)
    visit director_clients_path

    expect(page).to have_content("Hi, " + director.full_name)

    
    click_link("masquerade_link_#{client.id}")
    click_link("confirm-modal-link")

    expect(page).to have_content("Now masquerading as " + client.email)
    expect(page).to have_content("Hi, " + client.full_name)

    click_on "Stop Masquerading"
    expect(page).to have_content("Stopped masquerading")
    expect(page).to have_content("Hi, " + director.full_name)
  end

  scenario "when admins masquerade as clients", js: true do
    client
    sign_in(admin)
    visit admin_users_path

    expect(page).to have_content("Hi, " + admin.full_name)

    click_link("masquerade_link_#{client.id}")
    click_link("confirm-modal-link")

    expect(page).to have_content("Now masquerading as " + client.email)
    expect(page).to have_content("Hi, " + client.full_name)

    click_on "Stop Masquerading"
    expect(page).to have_content("Stopped masquerading")
    expect(page).to have_content("Hi, " + admin.full_name)
  end
end

