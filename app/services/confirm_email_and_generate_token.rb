# frozen_string_literal: true

class ConfirmEmailAndGenerateToken
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def email_activate
    user.email_confirmed = true
    user.confirm_token = nil
    user.save
  end

  def generate_token
    user.confirm_token = SecureRandom.urlsafe_base64.to_s if user.confirm_token.blank?
    user.save
  end
end
