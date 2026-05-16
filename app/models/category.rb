# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :user
  has_many :operations

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
