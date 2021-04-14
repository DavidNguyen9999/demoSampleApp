# frozen_string_literal: true

# Class CommentsController
class CommentsController < ApplicationController
  before_action :set_locale
  before_action :set_comment, only: [:destroy]
  before_action :new_comment, only: [:create]

  def create
    respond_to do |format|
      if @comment.save
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

  private

  def comment_params
    params.require(:comment).permit :micropost_id, :user_id, :content
  end

  def new_comment
    @comment = Comment.new(comment_params)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_locale
    I18n.locale = locale || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
