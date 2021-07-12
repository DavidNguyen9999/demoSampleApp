# frozen_string_literal: true

# Class OmniauthCallbacksController
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :fetch_user_oauth2, only: :google_oauth2
  before_action :fetch_user_oauth, only: :facebook
  before_action :fetch_user_oauth_discord, only: :discord
  skip_before_action :verify_authenticity_token, only: :discord
  def user_google_persisted?(user)
    if user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'

      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)

      redirect_to new_user_registration_url
    end
  end

  def user_facebook_persisted?(user)
    if user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Facebook'

      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.facebook_data'] = request.env['omniauth.auth'].except(:extra)

      redirect_to new_user_registration_url
    end
  end

  def fetch_user_oauth2
    @user = User.find_for_google_oauth2(request.env['omniauth.auth'])
  end

  def fetch_user_oauth
    @user = User.find_for_facebook_oauth(request.env['omniauth.auth'])
  end

  def facebook
    user_facebook_persisted?(@user)
  end

  def google_oauth2
    user_google_persisted?(@user)
  end

  def fetch_user_oauth_discord
    @user = User.find_for_discord_oauth(request.env['omniauth.auth'])
  end

  def user_discord_persisted?(user)
    if user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Discord'

      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.discord_data'] = request.env['omniauth.auth'].except(:extra)

      redirect_to new_user_registration_url
    end
  end

  def discord
    user_discord_persisted?(@user)
  end
end
