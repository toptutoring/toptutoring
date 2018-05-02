require "rails_helper"

feature "City crud specs" do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:city) { FactoryBot.create(:city) }
  let(:country) { FactoryBot.create(:country) }
  
  scenario "admin visits index path" do
    sign_in(admin)
    city
    visit admin_cities_path

    expect(page).to have_link "Add a City"
    expect(page).to have_link "Edit"
    expect(page).to have_link "Destroy"
    expect(page).to have_content "Name"
    expect(page).to have_content "Country"
    expect(page).to have_content "Phone Number"
    expect(page).to have_content city.name
    expect(page).to have_content city.country.name
    expect(page).to have_content Phonelib.parse(city.phone_number, city.country.code).national
  end

  scenario "admin adds a city with valid params" do
    country
    sign_in(admin)
    visit new_admin_city_path

    city_name = "NewCityName"
    city_phone_number = "(510) 555-5555"
    city_state = "State"
    city_address = "1234 Willow"
    city_zip = 94501

    fill_in "city_name", with: city_name
    fill_in "city_phone_number", with: city_phone_number
    fill_in "city_state", with: city_state
    fill_in "city_address", with: city_address
    fill_in "city_zip", with: city_zip
    fill_in "city_description", with: "A city's description."
    click_on "Create City"

    expect(page).to have_content city_name
    expect(page).to have_content city_phone_number
    expect(page).to have_content city_state
    expect(page).to have_content country.name
    expect(page).to have_content "#{city_name} has been added to the list of serviced cities."
    expect(City.count).to be 1
    new_city = City.last
    expect(new_city.address).to eq city_address
    expect(new_city.zip).to eq city_zip
    expect(new_city.slug).to eq city_name.downcase + "-" + city_state.downcase + "-tutoring"
  end

  scenario "editing a city with valid params" do
    sign_in(admin)
    visit edit_admin_city_path(city)

    city_name = "NewCityName"
    city_phone_number = "(510) 444-4444"

    fill_in "city_name", with: city_name
    fill_in "city_phone_number", with: city_phone_number
    fill_in "city_description", with: "Updated city description."
    click_on "Update City"

    expect(page).to have_content city_name
    expect(page).to have_content city_phone_number
    expect(page).to have_content "#{city_name} has been updated."
    expect(City.count).to be 1
  end

  scenario "admin removes a city" do
    sign_in(admin)
    name = city.name
    visit admin_cities_path

    click_on "Destroy"

    expect(page).to have_content "#{name} has been removed."
    expect(City.count).to eq 0
  end
end
