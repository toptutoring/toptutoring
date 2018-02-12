class NotificationsController < ApplicationController
  before_action :require_login

  def update
    @notice = Notification.find(params[:id])
    @notice.update(read: true)
    @count = current_user.notifications.unread.count
  end

  def mark_all
    notifications = current_user.notifications.unread
    notifications.update_all(read: true)
  end

  def destroy
    Notification.find(params[:id]).destroy!
    flash.alert = "Notification has been deleted."
    redirect_to action: :index
  end
end
