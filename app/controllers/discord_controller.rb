# frozen_string_literal: true

require 'discordrb'

# Class DiscordController
class DiscordController < ApplicationController
  before_action :create_invite_url

  def create
    @discord = current_user.discords.build(recipient_id: params[:id], discord_url: @invite)
    if @discord.save!
      redirect_to @invite
    else
      redirect_to root_path
    end
  end

  def create_invite_url
    @bot = Discordrb::Bot.new token: 'ODYzNzIyNDg3MzEyOTQxMDY3.YOrCQA.HhCIhnq8VayDXSfEnCG_Bk8EfsM'
    @bot.run :async
    id_server = '863986604942295060'
    @server = @bot.server(id_server.to_i)
    @create_channel = @server.create_channel("#{current_user.name}_#{params[:name]}")
    @invite = @create_channel.make_invite.url
  end
end
