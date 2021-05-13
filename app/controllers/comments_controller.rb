# frozen_string_literal: true

# Class CommentsController
class CommentsController < ApplicationController
  before_action :set_locale
  before_action :set_comment, only: [:destroy]
  before_action :new_comment, only: [:create]
  before_action :set_micropost, only: [:create]

  def create
    respond_to do |format|
      if @comment.save
        create_notification(@comment)
        format.html { redirect_to @comment, notice: t('controllers.comments.create.create_comment') }
        format.js
      else
        format.html { redirect_to @comment }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # redirect_back(fallback_location: @comments, notice: t('controllers.comments.destroy.destroy_success')) # Not Ajax
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to @comment, notice: t('controllers.comments.destroy.destroy_success') }
        format.js
      else
        format.html { redirect_to @comment, notice: t('controllers.comments.destroy.destroy_fails') }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def like
    @comment = Comment.find(params[:id])
    @comment.liked_by current_user
    respond_to do |format|
      format.html { redirect_to @comment }
      format.js { render :vote }
    end
  end

  def dislike
    @comment = Comment.find(params[:id])
    @comment.disliked_by current_user
    respond_to do |format|
      format.html { redirect_to @comment }
      format.js { render :vote }
    end
  end

  private

  def comment_params
    params.require(:comment).permit :micropost_id, :user_id, :content, :parent_id
  end

  def new_comment
    if params[:comment][:parent_id].to_i.positive?
      parent = Comment.find_by id: params[:comment].delete(:parent_id)
      @comment = parent.children.build comment_params
    else
      @comment = Comment.new(comment_params)
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_micropost
    @micropost = Micropost.find(@comment.micropost_id)
  end

  def destroy_all_children
    @comment.descendants.each(&:destroy)
  end

  def set_locale
    I18n.locale = locale || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def create_notification(comment)
    comment.notifications.create(user_id: @micropost.user_id, notified_by_id: current_user.id, event: 'New Comment')
  end
end
