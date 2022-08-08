# frozen_string_literal: true

class User < ApplicationRecord
  default_scope { where(is_deleted: false) }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                    length: { minimum: 4, maximum: 254 }

  validates :password, presence: true
end
