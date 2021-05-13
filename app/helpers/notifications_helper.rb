# frozen_string_literal: true

# Module NotificationHelpers
module NotificationsHelper
  def user_create_action(notification)
    if notification.event == 'New Vote'
      @voter = ActsAsVotable::Vote.find(@comment.voter_id)
      @voter
    else
      notification.notificationable.user
    end
  end

  def item_info(notification)
    notification.notificationable.content
  end

  def counter(notification)
    Notification.for_user(notification.user_id)
  end
end
