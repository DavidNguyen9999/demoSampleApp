# frozen_string_literal: true

# Class CommentsController
class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :new_comment, only: [:create]

  def index
    @comments = Comment.all
    @comment = Comment.new
  end

  def create
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.post, notice: 'Comment được tạo thành công' }
        format.js
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    # redirect_back(fallback_location: @comments) # Not Ajax
    respond_to do |format|
      format.html { redirect_to @comment, notice: 'Product was successfully destroyed.' }
      format.js
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
end
