# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :find_operation, only: %i[show edit update destroy]
  def index
    service = OperationQuery.new(params)
    scope = service.call.where(user: current_user)
    @pagy, @operations = pagy(scope.order(date: :desc), items: params[:page_size])

    @totals_operations = scope
                         .order(direction: :asc)
                         .group(:currency, :direction)
                         .pluck('sum(amount)', 'currency', 'direction')
    @params = index_params
    respond_to do |format|
      format.xlsx
      format.html
    end
  end

  def show
    render :show
  end

  def new
    @operation = Operation.new
  end

  def create
    if Category.where(id: operation_params[:category_id], user_id: current_user.id).empty?
      flash[:error] = 'This category is dinied for you!'
      redirect_to root_path
    else
      @operation = Operation.new(operation_params)
      if @operation.save
        flash[:notice] = "Operation '#{@operation.id}' successfully saved!"
        redirect_to action: 'index'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit; end

  def update
    if @operation.update(operation_params)
      flash[:notice] = 'Operation successfully updated!'
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @operation.destroy
    flash[:notice] = "Operation '#{@operation.id}' successfully deleted!"
    redirect_to operations_path, status: 303
  end

  private

  def operation_params
    params.require(:operation).permit(:direction, :category_id, :date, :amount, :currency).merge(user: current_user)
  end

  def index_params
    params.permit(:currency, :direction, :category, :date_start, :date_finish)
  end

  def find_operation
    operation = Operation.find(params[:id])
    if operation.user == current_user
      @operation = operation
    else
      flash[:notice] = 'This operation is dinied for you!'
      redirect_to root_path
    end
  end
end
