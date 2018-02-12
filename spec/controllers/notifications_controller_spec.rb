require "rails_helper"

describe NotificationsController, type: :controller do
  subject = NotificationsController
  let(:tutor) { FactoryBot.create(:tutor_user) }
  let!(:notification) { FactoryBot.create(:notification, user: tutor) }

  before(:each) do
    sign_in_as tutor
  end

  describe "#mark_all" do
    it "marks all unread notifications to read" do
      post :mark_all

      expect(flash.notice).to eq "Marked 1 notification as read."
      expect(notification.reload.read).to be true
    end

    it "does nothing if there are no unread notifications" do
      notification.update(read: true)
      post :mark_all

      expect(flash.alert).to eq "No notifications to mark as read."
      expect(notification.reload.read).to be true
    end
  end

  describe "#show" do
    it "marks notifications as read" do
      get :show, params: { id: notification.id }

      expect(notification.reload.read).to be true
    end
  end
end
