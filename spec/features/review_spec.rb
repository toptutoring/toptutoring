require "rails_helper"

feature "Add a review" do
  let(:client) { FactoryBot.create(:client_user) }

  scenario "when client gives a 5 star review", js: true do
    visit new_review_path(client.unique_token)
    expect(page).to have_content("Hello #{client.name}. Let us know how we're doing!")
    expect(page).to have_content("Rating")
    expect(page).to have_content("Review")

    review_text = "This is a review"

    fill_in "client_review_review", with: review_text
    find("label[for=client_review_stars_5]").click
    click_on "Submit Review"

    expect(page).to have_content "Thank you for your review!"
    expect(page).to have_link "Add a review to Google"
    expect(page).to have_content review_text
  end

  scenario "when client gives less than a 5 star review", js: true do
    visit new_review_path(client.unique_token)

    review_text = "This is a review"

    fill_in "client_review_review", with: review_text
    find("label[for=client_review_stars_4]").click
    click_on "Submit Review"

    expect(page).to have_content "Thank you for your review!"
    expect(page).not_to have_link "Add a review to Google"
    expect(page).to have_content review_text
  end
end
