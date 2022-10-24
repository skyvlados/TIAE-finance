# frozen_string_literal: true

class ConfirmRecoveryPasswordToken
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def new_password_activate
    user.password_digest = User.digest(@new_password)
    # user.confirm_recovery_password_token = nil
    user.save
  end

  def generate_token_for_recovery_password
    user.confirm_recovery_password_token = SecureRandom.urlsafe_base64.to_s
    user.save
  end
end
