# frozen_string_literal: true

class PasswordRecoveryController < ApplicationController
  def forgot_password; end

  def password_recovery
    @email = password_recovery_params[:email]
    if User.find_by(email: @email.downcase)
      @user = User.find_by_email(@email)
      user = ConfirmRecoveryPasswordToken.new(@user)
      user.generate_token_for_recovery_password
      @user.reload
      UserMailer.with(user: @user).password_recovery.deliver_now
      flash[:success] = "Letter with instruction send to your email adress #{@email}."
      redirect_to root_url
    else
      flash[:error] = 'This email hasn\'t been registered yet'
      redirect_to forgot_password_url
    end
  end

  def set_new_password_form
    @token = params[:token]
  end

  def set_new_password
    new_password = password_recovery_params[:password]
    token = password_recovery_params[:token]
    if new_password.blank?
      flash[:error] = 'Password cannot be empty!'
      redirect_to set_new_password_url
    else
      user = User.find_by_confirm_recovery_password_token(token)
      if user
        user.password_digest = User.digest(new_password)
        user.confirm_recovery_password_token = nil
        user.save
        flash[:success] = 'Your new password success saved! Enter your new password to login.'
      else
        flash[:error] = 'Sorry. User does not exist or password has already been recovered'
      end
      redirect_to root_url
    end
  end

  private

  def password_recovery_params
    params.require(:user).permit(:email, :password, :token)
  end
end
