# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :check_session
  def new; end

  def create
    @button_repeat_send = false
    user = User.find_by(email: params[:session][:email].downcase, is_deleted: false)
    if user&.authenticate(params[:session][:password])
      if user.email_confirmed
        log_in user
        redirect_to root_path
      else
        flash.now[:error] =
          'Please activate your account.
           For it fill this folders and click "Send confirm email" and following the instructions
           in the account confirmation email you received to proceed.'
        @button_repeat_send = true
        @email = user.email
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new, status: :unprocessable_entity
    end
  end

  def send_confirm_email
    @user = User.find_by_email(params[:session][:email])
    user = ConfirmEmailQuery.new(@user)
    user.confirmation_token
    @user = User.find_by_email(params[:session][:email])
    UserMailer.registration_confirmation(@user).deliver_now
    flash.now[:error] =
      'Email sucess sent!'
    render :new, status: :unprocessable_entity
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
