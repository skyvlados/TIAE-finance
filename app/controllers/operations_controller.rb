# frozen_string_literal: true

class OperationsController < ApplicationController
  before_action :find_operation, only: %i[show edit update destroy]
  def index
    service = OperationQuery.new(params)
    scope = service.call.where(user: current_user)

    @totals_operations = scope
                         .reorder(direction: :asc)
                         .group(:currency, :direction)
                         .pluck('sum(amount)', 'currency', 'direction')

    @params = index_params

    if index_params.present?
      cookies[:operations_filters] = JSON.generate(**index_params)
    else
      cookies.delete :operations_filters
    end

    respond_to do |format|
      format.xlsx do
        @operations = scope
      end

      format.html do
        @pagy, @operations = pagy(
          scope,
          items: @params[:page_size]
        )
      end
    end
  end

  def show; end

  def new
    @operation = Operation.new
  end

  def create
    @operation = Operation.new(operation_params)
    category = available_categories_for_user(operation_params[:category_id])

    if category.blank?
      render :new, status: :forbidden
      return
    end

    if @operation.save
      flash[:notice] = "Operation '#{@operation.id}' successfully saved!"
      operations_filters = JSON.parse(cookies[:operations_filters] || '{}')
      redirect_to action: 'index', **operations_filters
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    category = available_categories_for_user(operation_params[:category_id])

    if category.blank?
      render :new, status: :forbidden
      return
    end

    if @operation.update(operation_params)
      flash[:notice] = 'Operation successfully updated!'
      operations_filters = JSON.parse(cookies[:operations_filters] || '{}')
      redirect_to action: 'index', **operations_filters
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @operation.destroy
    flash[:notice] = "Operation '#{@operation.id}' successfully deleted!"
    redirect_to operations_path, status: 303
  end

  def mass_delete
    Operation.delete(mass_delete_params[:operations_ids])
    flash[:notice] = 'Operations successfully deleted!'
    redirect_to action: 'index'
  rescue ActionController::ParameterMissing
    flash[:info] = 'First of all choose at least one operation!'
    redirect_to operations_path, status: 303
  end

  private

  def mass_delete_params
    params.require(:cleaner).permit(operations_ids: [])
  end

  def operation_params
    params.require(:operation)
          .permit(:direction, :category_id, :date, :amount, :currency, :comment)
          .merge(user: current_user)
  end

  def index_params
    params.permit(:currency,
                  :direction,
                  :category,
                  :date_start,
                  date_finish,
                  :comment,
                  :order_by_date,
                  :page_size,
                  :page)
  end

  def find_operation
    operation = Operation.find(params[:id])
    if operation.user == current_user
      @operation = operation
    else
      flash[:info] = 'This operation is dinied for you!'
      redirect_to root_path
    end
  end

  def available_categories_for_user(id)
    current_user.categories.where(id: id)
  end
end
