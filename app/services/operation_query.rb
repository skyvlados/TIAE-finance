# frozen_string_literal: true

class OperationQuery
  attr_reader :params

  TRANSLATE_ORDER_PARAMS = { desc: 'Descending', asc: 'Ascending' }.freeze
  def initialize(params)
    @params = params
  end

  def call
    Operation
      .then { |scope| filter_by_currency scope }
      .then { |scope| filter_by_direction scope }
      .then { |scope| filter_by_category scope }
      .then { |scope| filter_by_dates scope }
      .then { |scope| order_by_date scope }
  end

  def order_by_date(scope)
    return scope.order(date: :desc) if params[:order_by_date].blank?
    raise ArgumentError unless TRANSLATE_ORDER_PARAMS.values.include?(params[:order_by_date])

    order_type = OperationQuery::TRANSLATE_ORDER_PARAMS.key(params[:order_by_date])

    scope.order(date: order_type)
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
