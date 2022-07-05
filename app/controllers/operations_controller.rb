class OperationsController < ApplicationController
  def index
    @operations=Operation.includes(:category).all
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
    @operation=Operation.find(params[:id])
  end

  def update
    @operation=Operation.find(params[:id])
    if @operation.update(operation_params)
      redirect_to action: "index"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Operation.find(params[:id]).destroy
    redirect_to operations_path, status: 303
  end

  def operation_params
    params.require(:operation).permit(:direction, :category_id, :date, :amount, :currency)
  end
end
