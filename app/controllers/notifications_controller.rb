# frozen_string_literal: true

# Class NotificationsController
class NotificationsController < ApplicationController
  load_and_authorize_resource

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.update(seen: true)
    redirect_to @notification.notificationable.micropost.user
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.update(seen: true)
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end
end
