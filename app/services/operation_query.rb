# frozen_string_literal: true

class OperationQuery
  attr_reader :params

  TRANSLATE_ORDER_PARAMS = [{ asc: 'Ascending' }, { desc: 'Descending' }].freeze
  def initialize(params)
    @params = params
  end

  def call
    Operation
      .then { |scope| filter_by_currency scope }
      .then { |scope| filter_by_direction scope }
      .then { |scope| filter_by_category scope }
      .then { |scope| filter_by_dates scope }
      .then { |scope| filter_order_by_data scope }
  end

  def filter_order_by_data(scope)
    if validate_order_by_value
      allowed_key_from_params = OperationQuery::TRANSLATE_ORDER_PARAMS
              .select { |order| order.values[0] == params[:order_by_data] }
              .first
              .key(params[:order_by_data])
              .to_sym
      scope.order(date: allowed_key_from_params)
    else
      scope.order(date: :desc)
    end
  end

  def validate_order_by_value
    OperationQuery::TRANSLATE_ORDER_PARAMS.map(&:values).flatten.include?(params[:order_by_data])
  end

  def filter_by_currency(scope)
    return scope if params[:currency].blank?

    scope.where(currency: params[:currency])
  end

  def filter_by_direction(scope)
    return scope if params[:direction].blank?

    scope.where(direction: params[:direction])
  end

  def filter_by_category(scope)
    return scope if params[:category].blank?

    scope.where(category: params[:category])
  end

  def filter_by_dates(scope)
    scope = scope.where('date>= ?', params[:date_start]) if params[:date_start].present?
    scope = scope.where('date<= ?', params[:date_finish]) if params[:date_finish].present?
    scope
  end
end
