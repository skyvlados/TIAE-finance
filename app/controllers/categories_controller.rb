# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order('id ASC').paginate(page: params[:page], per_page: 10)
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category '#{@category.name}' successfully saved!"
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    old_name = @category.name

    if @category.update(category_params)
      flash[:notice] = "Category '#{old_name}' successfully updated to '#{@category.name}'!"
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:notice] = "Category '#{@category.name}' successfully deleted!"
    redirect_to categories_path, status: 303
  rescue ActiveRecord::InvalidForeignKey
    flash[:error] = "Category '#{@category.name}' cannot be deleted due to being associated with an operation!"
    redirect_to categories_path, status: 303
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
