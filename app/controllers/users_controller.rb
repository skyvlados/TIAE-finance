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
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User created!'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    render :edit
  end

  def update
    old_name = @user.name
    old_telegram_id = @user.telegram_id
    if @user.update(user_params)
      flash[:notice] = if old_name != @user.name && old_telegram_id == @user.telegram_id
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
    params.require(:user).permit(:name, :telegram_id)
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
