require "rails_helper"

feature "Edit funding source" do
  let(:admin) { User.admin }
  let(:response) { Struct.new(:name, :id) }

  scenario "redirects to edit and has valid form" do
    funding_source = FactoryBot.create(:funding_source)
    name = "Name of Funds"
    dwolla_stub_success([response.new(name, funding_source.funding_source_id), response.new("Balance", "id")])

    sign_in(admin)
    visit new_admin_funding_source_path

    expect(page).to have_current_path(edit_admin_funding_source_path(FundingSource.first))
    expect(page).to have_select("funding_source_funding_source_id", selected: name)
  end

  scenario "with invalid params" do
    dwolla_stub_success([])

    sign_in(admin)
    visit new_admin_funding_source_path

    select "", from: "funding_source_funding_source_id"
    click_button "Set Funding source"
    expect(page).to have_content("Funding source can't be blank")
  end

  scenario "with valid params" do
    name = "Name of Funds"
    dwolla_stub_success([response.new(name, "id")])

    sign_in(admin)
    visit new_admin_funding_source_path

    select name, from: "funding_source_funding_source_id"
    click_button "Set Funding source"
    expect(page).to have_content("Funding source successfully set.")
  end
end
