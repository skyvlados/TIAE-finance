# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: 'tiaefinance@mail.ru'

  def registration_confirmation
    @user = params[:user]
    mail(to: @user.email, subject: 'Registration Confirmation')
  end

  def password_recovery
    @user = params[:user]
    mail(to: @user.email, subject: 'Password recovery')
  end
end
