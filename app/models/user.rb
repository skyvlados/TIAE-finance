# frozen_string_literal: true

class User < ApplicationRecord

  validates :name, presence: true
  validates :telegram_id, presence: true, uniqueness: true
  has_many :operations
  has_many :categories
  default_scope { where(is_deleted: false) }
end
