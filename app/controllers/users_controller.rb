# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit update destroy]
  def index
    service = UserQuery.new(params)
    scope = service.call
    @pagy, @users = pagy(scope.order(id: :desc).where(is_deleted: false), items: params[:page_size])
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    user_params[:email].downcase!
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:notice] = 'Welcome to the TIAE finance App!'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password_digest)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
