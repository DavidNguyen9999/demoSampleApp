# frozen_string_literal: true

# Class UserController
class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where.not(confirmed_at: nil).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    # redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
    @comment = Comment.new
    @post = Micropost.find(params[:id])
    @comments = @post.comments.all
    @comments = Comment.hash_tree
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:success] = if @user.email != current_user.email
                          "#{user_params[:name]}(#{user_params[:email]}) Profile updated by SuperAdmin"
                        else
                          ' Your Profile updated'
                        end
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
end
