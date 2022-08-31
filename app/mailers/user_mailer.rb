# frozen_string_literal: true

class UserMailer < ActionMailer::Base
  default from: 'tiaefinance@mail.ru'

  def registration_confirmation(user)
    @user = user
    mail(to: @user.email, subject: 'Registration Confirmation')
  end
end
