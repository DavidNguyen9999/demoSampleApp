class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification, user_id)
    notification_count = Notification.for_user(notification.user_id)
    ActionCable.server.broadcast "notifications.#{user_id}", { counter: notification_count, layout: render_notification(notification) }
  end

  private

  def render_notification(notification)
    ApplicationController.renderer.render(partial: 'notifications/notification', locals: { notification: notification })
  end
end
