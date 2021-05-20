# frozen_string_literal: true

# Class MicropostsController
class MicropostsController < ApplicationController
  load_and_authorize_resource
  before_action :user_signed_in?, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def micropost_save(micropost)
    if micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    micropost_save(@micropost)
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
