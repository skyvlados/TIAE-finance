# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :find_operation, only: %i[show edit update destroy]
  def index
    service = OperationQuery.new(params)
    scope = service.call
    user_id = current_user.id
    @pagy, @operations = pagy(scope.order(date: :desc).where(user_id: user_id), items: params[:page_size])

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
    if current_user.present?
      render :show
    else
      redirect_to root_path
    end
  end

  def new
    if current_user.present?
      @operation = Operation.new
    else
      redirect_to root_path
    end
  end

  def create
    @operation = Operation.new(operation_params.merge(user_id: current_user.id))
    if @operation.save
      flash[:notice] = "Operation '#{@operation.id}' successfully saved!"
      redirect_to action: 'index'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.present?
      render :edit
    else
      redirect_to root_path
    end
  end

  def update
    if @operation.update(operation_params.merge(user_id: current_user.id))
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
    params.require(:operation).permit(:direction, :category_id, :date, :amount, :currency)
  end

  def index_params
    params.permit(:currency, :direction, :category, :date_start, :date_finish)
  end

  def find_operation
    @operation = Operation.find(params[:id])
  end
end
