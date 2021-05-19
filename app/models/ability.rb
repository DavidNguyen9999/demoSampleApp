# frozen_string_literal: true

# class Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, :all if user.has_role? :super_admin
    if user.has_role? :admin
      can :manage, :all
      can :manage, User, id: user.id
      not_alow_for_admin
    else
      can :read, User
      action_for_user(user)
    end
  end

  def not_alow_for_admin
    cannot :edit, User, User.all.each do |u|
      u.has_role?(:super_admin || :admin)
    end
    cannot :destroy, User, User.all.each do |u|
      u.has_role?(:super_admin || :admin)
    end
  end

  def action_for_user(user)
    can :manage, Comment, user_id: user.id
    can :manage, Micropost, user_id: user.id
    can :manage, Notification, user_id: user.id
    can :manage, Relationship, follower_id: user.id
    can :manage, User, id: user.id
    cannot :destroy, User, id: user.id
  end
end
