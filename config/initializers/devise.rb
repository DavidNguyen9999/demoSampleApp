Devise.setup do |config|
  config.mailer_sender = "SampleApp <haianh13041999@gmail.com>"

  require "devise/orm/active_record"

  config.secret_key = "b6a94131a7bb70043fce9677dcd591eb9109ba55f3653eb7d79f533f4c8edf1b10f121fd425fff5d95a4177cbc777e79cf26cbf59d126e6d3514a681f5f1e9a2"

  config.scoped_views = true

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10

  config.reconfirmable = false

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

  config.timeout_in = 10.days

  config.lock_strategy = :failed_attempts

  config.unlock_keys = [:email]

  config.unlock_strategy = :both

  config.maximum_attempts = 5

  config.unlock_in = 10.minutes

  config.last_attempt_warning = true

  config.omniauth :google_oauth2, "612600325820-36tj0vf3di1403o6vg36lcpnct1r9s90.apps.googleusercontent.com", "hRASIStfzLiU9ueZmpiryO_J", scope: 'email,profile', image_aspect_ratio: 'square', image_size: 50, info_fields: 'email,name'

  config.omniauth :facebook, "1102717176874885", "5b647b1047ed5b4f99f4b2960712c702", scope: 'email,public_profile', info_fields: 'email,name'

  config.omniauth :discord, "863722487312941067", "m62Vz1r1z9-mmoc9SnX7tErKVPCxQz_v", scope:'email identify', callback_url: 'https://localhost:3000/auth/discord/callback'
end
