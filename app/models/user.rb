# frozen_string_literal: true

class User < ApplicationRecord
  has_many :operations
  default_scope { where(is_deleted: false) }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                    length: { minimum: 4, maximum: 254 }
  has_secure_password
  validates :password_digest, presence: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end
end
