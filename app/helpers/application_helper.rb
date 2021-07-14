# frozen_string_literal: true

# Class ApplicationHelper
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_title.empty?
      base_title
    else
      "#{page_title}  |  #{base_title}"
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user && user == current_user
  end

  def discord_url(sender_id, recipient_id)
    @conversation = Conversation.find_messenger(sender_id, recipient_id).first
    @discord = Discord.find_by(recipient_id: @conversation.recipient_id)
    return false if @discord.nil?

    @url = @discord.discord_url
  end
end
