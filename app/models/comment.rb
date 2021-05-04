# frozen_string_literal: true

# Class Comment
class Comment < ApplicationRecord
  acts_as_votable
  acts_as_tree order: 'created_at ASC', dependent: :delete_all
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :childrens, class_name: 'Comment', foreign_key: 'parent_id'
  belongs_to :user
  belongs_to :micropost

  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
