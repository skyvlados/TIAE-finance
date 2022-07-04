class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category=Category.new(category_params)
      if @category.save
        redirect_to action: "index"
      else
        render :new, status: :unprocessable_entity
       end
  end

  def edit
    @category=Category.find(params[:id])
  end

  def update
    @category=Category.find(params[:id])
    if @category.update(category_params)
      redirect_to action: "index"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    redirect_to categories_path, status: 303
  end

  def category_params
        params.require(:category).permit(:name)
      end
end
