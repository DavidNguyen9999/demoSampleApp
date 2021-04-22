# frozen_string_literal: true

# Class Comment
class Comment < ApplicationRecord
  acts_as_votable
  belongs_to :user
  belongs_to :micropost

  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
