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
end
