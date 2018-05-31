require "rails_helper"

feature "Set funding source" do
  let(:admin) { User.admin }
  let(:response) { Struct.new(:name, :id) }

  scenario "goes to new when admin is not authorized" do
    name = "Name of Funds"
    dwolla_stub_success([])

    sign_in(admin)
    visit new_admin_funding_source_path
    expect(page).to have_current_path(new_admin_funding_source_path)
  end

  scenario "with invalid params" do
    dwolla_stub_success([response.new("Name", "id")])

    sign_in(admin)
    visit new_admin_funding_source_path
    click_button "Set Funding source"
    expect(page).to have_content("Funding source can't be blank")
  end

  scenario "with valid params" do
    name = "Name of Funds"
    dwolla_stub_success([response.new(name, "id"), response.new("Balance", "id2")])

    sign_in(admin)
    visit new_admin_funding_source_path
    select name, from: "funding_source_funding_source_id"
    click_button "Set Funding source"
    expect(page).to have_content("Funding source successfully set.")
  end
end
