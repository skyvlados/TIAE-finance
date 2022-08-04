# frozen_string_literal: true

class UsersController < ApplicationController

    def index
        users = User.all
        @pagy, @users = pagy(users.order(id: :desc), items: params[:page_size])
    end

    def show
        @user = User.find(params[:id])
    end
  
    def new
      @user = User.new
    end

    def create
        user_params[:email].downcase!
        @user = User.new(user_params)
        if @user.save
          flash[:notice] = "User '#{@user.name}' successfully saved!"
          redirect_to root_path
        else
          render :new, status: :unprocessable_entity
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        user_params[:email].downcase!
        @user = User.find(params[:id])
        if @user.update(user_params)
          flash[:notice] = "User '#{@user.name}' successfully edited!"
          redirect_to root_path
        else
          render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        flash[:notice] = "Operation '#{@user.name}' successfully deleted!"
        redirect_to users_path, status: 303
    end

    private
    
    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
end
