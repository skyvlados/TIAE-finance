# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_category, only: %i[show edit update destroy]
  def index
    @params = index_params

    if index_params.present?
      cookies[:categories_filters] = JSON.generate(**index_params)
    else
      cookies.delete :categories_filters
    end

    @pagy, @categories = Category
                         .order(id: :asc)
                         .where(user: current_user)
                         .then { |scope| filter_by_name scope }
                         .then { |scope| pagy(scope, items: page_size(@params[:page_size])) }
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category '#{@category.name}' successfully saved!"
      categories_filters = JSON.parse(cookies[:categories_filters] || '{}')
      redirect_to action: 'index', **categories_filters
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    old_name = @category.name

    if @category.update(category_params)
      flash[:notice] = "Category '#{old_name}' successfully updated to '#{@category.name}'!"
      categories_filters = JSON.parse(cookies[:categories_filters] || '{}')
      redirect_to action: 'index', **categories_filters
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Category '#{@category.name}' successfully deleted!"
    redirect_to categories_path, status: 303
  rescue ActiveRecord::InvalidForeignKey
    flash[:error] =
      "Category '#{@category.name}' cannot be deleted due to being associated with an operation!"
    redirect_to categories_path, status: 303
  end

  private

  def category_params
    params.require(:category).permit(:name).merge(user: current_user)
  end

  def index_params
    params.permit(:name,
                  :page_size,
                  :page)
  end

  def find_category
    category = Category.find(params[:id])
    if category.user == current_user
      @category = category
    else
      flash[:info] = 'This category is dinied for you!'
      redirect_to root_path
    end
  end

  def filter_by_name(scope)
    scope = scope.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?
    scope
  end
end
