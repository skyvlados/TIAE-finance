# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :check_session
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase, is_deleted: false)
    if user&.authenticate(params[:session][:password])
      if user.email_confirmed
        log_in user
        redirect_to root_path
      else
        flash.now[:error] =
          'Please activate your account by following the instructions
           in the account confirmation email you received to proceed'
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
