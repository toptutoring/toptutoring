require "rails_helper"

feature "Masquerading" do
  let!(:client) { FactoryBot.create(:client_user) }
  let(:director) { FactoryBot.create(:director_user) }
  let(:admin) { FactoryBot.create(:admin_user) }

  scenario "when directors masquerade as clients" do
    client
    sign_in(director)
    visit director_users_path

    expect(page).to have_content("Hi, " + director.name)

    click_on "Masquerade"

    expect(page).to have_content("Now masquerading as " + client.email)
    expect(page).to have_content("Hi, " + client.name)

    click_on "Stop Masquerading"
    expect(page).to have_content("Stopped masquerading")
    expect(page).to have_content("Hi, " + director.name)
  end

  scenario "when admins masquerade as clients" do
    client
    sign_in(admin)
    visit admin_users_path

    expect(page).to have_content("Hi, " + admin.name)

    click_on "Masquerade"

    expect(page).to have_content("Now masquerading as " + client.email)
    expect(page).to have_content("Hi, " + client.name)

    click_on "Stop Masquerading"
    expect(page).to have_content("Stopped masquerading")
    expect(page).to have_content("Hi, " + admin.name)
  end
end

