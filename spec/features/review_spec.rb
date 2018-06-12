require "rails_helper"

def make_purchase(client)
  sign_in client
  visit new_clients_payment_path

  allow_any_instance_of(Clients::PaymentsController).to receive(:token_id) { "tok_visa" }
  allow_any_instance_of(ClientAccount).to receive(:request_review?) { true }

  fill_in "payment_hours_purchased", with: 2
  fill_in "card_holder_name", with: client.full_name
  fill_in "card_address", with: "1234 Address"
  fill_in "card_city", with: "City"
  fill_in "card_zip_code", with: "01234"
  click_on "Purchase Hours"
end

feature "Add a review" do
  let(:client) { FactoryBot.create(:client_user) }
  let!(:engagement) { FactoryBot.create(:engagement, client_account: client.client_account) }

  scenario "when client gives a 5 star review", js: true do
    make_purchase(client)
    expect(page).to have_content(I18n.t("app.clients.reviews.heading"))
    expect(page).to have_content I18n.t("app.clients.reviews.request_rating", name: client.full_name)

    find("label[for=client_review_stars_5]").click
    click_on "Submit Rating"

    expect(page).to have_content I18n.t("app.clients.reviews.request_external_review_html", href: ENV.fetch("DEFAULT_REVIEW_SOURCE"))
    expect(page).to have_link href: ENV.fetch("DEFAULT_REVIEW_LINK")
    review = ClientReview.last
    expect(review.stars).to eq 5
    expect(review.review_link).to eq ENV.fetch("DEFAULT_REVIEW_LINK")
    expect(review.review_source).to eq ENV.fetch("DEFAULT_REVIEW_SOURCE")
  end

  scenario "when client gives a 5 star review and has a location/link set", js: true do
    link = "https://www.example.com"
    location = "Example Review Site"
    client.client_account.update(review_link: link, review_source: location)
    make_purchase(client)
    expect(page).to have_content(I18n.t("app.clients.reviews.heading"))
    expect(page).to have_content I18n.t("app.clients.reviews.request_rating", name: client.full_name)

    find("label[for=client_review_stars_5]").click
    click_on "Submit Rating"

    expect(page).to have_content I18n.t("app.clients.reviews.request_external_review_html", href: location)
    expect(page).to have_link href: link
    review = ClientReview.last
    expect(review.stars).to eq 5
    expect(review.review_link).to eq link
    expect(review.review_source).to eq location
  end

  scenario "when client gives less than a 5 star review", js: true do
    make_purchase(client)
    find("label[for=client_review_stars_4]").click
    click_on "Submit Rating"

    review_text = "This is a review"
    fill_in "client_review_review", with: review_text
    click_on "Submit Review"

    expect(page).to have_content I18n.t("app.clients.reviews.thank_you")
    expect(page).to have_content review_text

    review = ClientReview.last
    expect(review.stars).to eq 4
    expect(review.review).to eq review_text
  end
end
