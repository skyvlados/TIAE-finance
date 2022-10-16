# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_is_admin, only: %i[index show edit update destroy]
  before_action :find_user, only: %i[show edit update destroy]
  skip_before_action :check_session, only: %i[new create]
  def index
    service = UserQuery.new(params)
    scope = service.call
    @pagy, @users = pagy(scope, items: params[:page_size])
  end

  def show
    render :show
  end

  def new
    @user = User.new
  end

  def create
    user_params[:email].downcase!
    @user = User.new(user_params)
    if @user.save
      @user.gen_token
      UserMailer.with(user: @user).registration_confirmation.deliver_now
      flash[:notice] = 'You are registered. To continue you need confirm email, check your email'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    render :edit
  end

  def update
    user_params[:email].downcase!
    old_name = @user.name
    old_email = @user.email
    if @user.update(user_params)
      flash[:notice] = if old_name != @user.name && old_email == @user.email
                         "User '#{old_name}' successfully updated to '#{@user.name}'!"
                       else
                         "User '#{@user.name}' successfully updated!"
                       end
      redirect_to users_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user.update(is_deleted: true)
    flash[:notice] = "User '#{@user.name}' successfully deleted!"
    redirect_to users_path, status: 303
  end

  def forgot_password
    render :forgot_password
  end

  def password_recovery
    @email = user_params[:email]
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
    @@password_recovery_token = request.fullpath.split('/')[2]
    render :set_new_password_form
  end

  def set_new_password
    if user_params[:password].blank?
      flash[:error] = 'Password cannot be empty!'
      redirect_to set_new_password_url
    else
      @new_password = user_params[:password]
      user = User.find_by_confirm_recovery_password_token(@@password_recovery_token)
      if user
        user.password_digest = User.digest(@new_password)
        user.confirm_recovery_password_token = nil
        user.save
        flash[:success] = 'Your new password success saved! Enter your new password to login.'

      else
        flash[:error] = 'Sorry. User does not exist or password has already been recovered'
      end
      redirect_to root_url
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:token])
    if user
      service = ConfirmEmailAndGenerateToken.new(user)
      service.email_activate
      flash[:success] = 'Welcome to the Sample App! Your email has been confirmed. Please sign in to continue.'
    else
      flash[:error] = 'Sorry. User does not exist'
    end
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def user_is_admin
    unless User.find(current_user.id).is_admin
      flash[:notice] = 'You aren\'t an admin!'
      redirect_to root_path
    end
  end
end
