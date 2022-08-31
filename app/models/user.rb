# frozen_string_literal: true

class User < ApplicationRecord
  before_create :confirmation_token
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

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(validate: false)
  end

  private

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end
end
