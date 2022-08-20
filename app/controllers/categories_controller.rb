# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_category, only: %i[show edit update destroy]
  def index
    @pagy, @categories = Category.order(id: :asc).where(user: current_user)
                                 .then { |scope| pagy(scope, items: params[:items]) }
  end

  def show
    if @category.user == current_user
      render :show
    else
      flash[:notice] = 'This category is dinied for you!'
      redirect_to root_path
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params.merge(user: current_user))
    if @category.save
      flash[:notice] = "Category '#{@category.name}' successfully saved!"
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    old_name = @category.name

    if @category.update(category_params.merge(user: current_user))
      flash[:notice] = "Category '#{old_name}' successfully updated to '#{@category.name}'!"
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Category '#{@category.name}' successfully deleted!"
    redirect_to categories_path, status: 303
  rescue ActiveRecord::InvalidForeignKey
    flash[:error] = "Category '#{@category.name}' cannot be deleted due to being associated with an operation!"
    redirect_to categories_path, status: 303
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find(params[:id])
  end
end
