module NotificationHelper
  def notification_count(user)
    count = user.notifications.unread.count
    return if count < 1
    tag.span(count, class: "badge bg-danger")
  end

  def user_notifications_list(user)
    if user.notifications.unread.any?
      capture do
        user.notifications.unread.each do |notice|
          concat notification_list_item(notice)
        end
      end
    else
      render "notifications/no_messages"
    end
  end

  private

  def notification_list_item(notice)
    tag.li class: "media", id: "notification_#{notice.id}" do
      link_to notification_path(notice), method: :patch, remote: true do
        concat icon(notice)
        concat message(notice)
      end
    end
  end

  def icon(notice)
    icon_class = "media-object mo-md img-circle text-center bg-success"
    icon_type = case notice.message_type
                when "invoice" then " ion-cash"
                when "alert" then " ion-alert"
                else " ion-ios-email"
                end
    tag.div class: "media-left" do
      concat tag.i class: icon_class + icon_type
    end
  end

  def message(notice)
    tag.div class: "media-body" do
      concat tag.h5 notice.title, class: "media-heading"
      concat tag.p notice.message, class: "text-muted mb-0"
    end
  end
end
