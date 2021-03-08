module UsersHelper
  require "uri"
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    if user.image
      user.image
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase

      "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
  end
end
