require 'spec_helper'
require "rails_helper"

feature "Director edits user balance" do
  let(:client) { FactoryGirl.create(:client_user) }
  let(:director) { FactoryGirl.create(:director_user) }

  context "is submitted successfully" do
    scenario "for credits" do
      sign_in(director)

      visit edit_director_user_path(client)
      fill_in "Academic Credit (in hours)", with: 2
      fill_in "Test Prep Credit", with: 3.25
      click_on "Submit"

      expect(page).to have_content("Client info is successfully updated!")
    end

    scenario "for rates" do
      sign_in(director)

      visit edit_director_user_path(client)
      fill_in "Academic Rate", with: 10
      fill_in "Test Prep Rate", with: 49.99
      click_on "Submit"

      expect(page).to have_content("Client info is successfully updated!")
    end
  end

  context "is submitted with bad credit values" do
    scenario "for academic credit" do
      sign_in(director)

      visit edit_director_user_path(client)
      fill_in "Academic Credit (in hours)", with: 0.001
      click_on "Submit"

      expect(page).to have_content("Credits must be in quarter hours")
    end

    scenario "for test prep credit" do
      sign_in(director)

      visit edit_director_user_path(client)
      fill_in "Test Prep Credit (in hours)", with: 0.001
      click_on "Submit"

      expect(page).to have_content("Credits must be in quarter hours")
    end
  end

  context "is submitted with bad dollar values" do
    scenario "for academic rate" do
      sign_in(director)

      visit edit_director_user_path(client)
      fill_in "Academic Rate", with: 0.001
      click_on "Submit"

      expect(page).to have_content("Rates must be in correct dollar values")
    end

    scenario "for academic rate" do
      sign_in(director)

      visit edit_director_user_path(client)
      fill_in "Test Prep Rate", with: 0.123
      click_on "Submit"

      expect(page).to have_content("Rates must be in correct dollar values")
    end
  end
end
