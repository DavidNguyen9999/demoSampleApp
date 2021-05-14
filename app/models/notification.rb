# frozen_string_literal: true

# Class Notification
class Notification < ApplicationRecord
  belongs_to :notified_by, class_name: 'User'
  belongs_to :user
  belongs_to :notificationable, polymorphic: true
  after_create :create_notification, :send_mail
  scope :unviewed, -> { where(seen: false) }
  def create_notification
    NotificationBroadcastJob.set(wait: 1.seconds).perform_later(self, user_id)
  end

  def send_mail
    UserMailer.notification(self).deliver_later
  end

  def self.for_user(user_id)
    Notification.where(user_id: user_id).unviewed.count
  end
end
