require "rails_helper"

feature "Country crud specs" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:country) { FactoryBot.create(:country) }
  
  scenario "admin visits index path" do
    country
    sign_in(admin)
    visit new_country_path

    expect(page).to have_button "Create Country"
    expect(page).to have_link "Edit"
    expect(page).to have_link "Destroy"
    expect(page).to have_content "Name"
    expect(page).to have_content country.name
    expect(page).to have_content country.code
  end

  scenario "admin adds a country" do
    sign_in(admin)
    visit new_country_path

    country_name = "NewCountryName"
    country_code = "code"

    fill_in "country_name", with: country_name
    fill_in "country_code", with: country_code
    click_on "Create Country"

    expect(page).to have_content country_name
    expect(page).to have_content country_code
    expect(page).to have_content "#{country_name} has been added to the list of serviced countries."
    expect(Country.count).to be 1
  end

  scenario "editing a country with valid params" do
    sign_in(admin)
    visit edit_country_path(country)

    country_name = "NewCountryName"
    country_code = "code"

    fill_in "country_name", with: country_name
    fill_in "country_code", with: country_code
    click_on "Update Country"

    expect(page).to have_content country_name
    expect(page).to have_content country_code
    expect(page).to have_content "#{country_name} has been updated."
    expect(Country.count).to be 1
  end

  scenario "admin removes a country" do
    sign_in(admin)
    name = country.name
    visit new_country_path

    click_on "Destroy"

    expect(page).to have_content "#{name} has been removed."
    expect(Country.count).to eq 0
  end
end
