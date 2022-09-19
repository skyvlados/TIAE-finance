# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :operations
  has_many :categories
  default_scope { where(is_deleted: false) }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                    length: { minimum: 4, maximum: 254 }
  validates :password_digest, presence: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def gen_token
    ConfirmEmailAndGenerateToken.new(self).generate_token
  end
end
