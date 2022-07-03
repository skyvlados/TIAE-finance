class OperationsController < ApplicationController
  def index
    @operations=Operation.all
  end

  def show
    @operation = Operation.find(params[:id])
  end

  def new
    @operation=Operation.new
  end

  def create
    @operation=Operation.new(operation_params)
    if @operation.save
        redirect_to action: "index"
    else
        render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def operation_params
    params.require(:operation).permit(:categories_type)
    params.require(:operation).permit(:category_id)
    params.require(:operation).permit(:date)
    params.require(:operation).permit(:amount)
    params.require(:operation).permit(:currency)
  end
end
