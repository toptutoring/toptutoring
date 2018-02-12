require "rails_helper"

feature "User interacts with notifications" do
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let!(:notification) { FactoryBot.create(:notification, user: tutor) }

  scenario "visits index" do
    sign_in tutor
    visit notifications_path
    expect(page).to have_content(notification.message)
    expect(page).to have_content(notification.title)
    expect(page).to have_link("Mark as read")
    expect(page).to have_link("Delete")
  end

  scenario "marks notification as read" do
    sign_in tutor
    visit notifications_path
    click_on "Mark as read"

    expect(page).to have_content("Notification has been marked as read.")
    expect(page).not_to have_link("Mark as read")
  end

  scenario "visits show" do
    sign_in tutor
    visit notification_path(notification)

    delete_link = find_link(href: notification_path(notification))
    expect(page).to have_content(notification.message)
    expect(page).to have_content(notification.title)
    expect(delete_link.matches_selector?("a[data-method='delete']")).to be true
  end
end
