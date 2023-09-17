# frozen_string_literal: true

class OperationQuery
  attr_reader :params

  TRANSLATE_ORDER_PARAMS = [{ name: 'Descending', value: :desc }, { name: 'Ascending', value: :asc }].freeze
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
    param_is_valid = TRANSLATE_ORDER_PARAMS.pluck(:name).include?(params[:order_by_date]) ||
                     !params.keys.include?('order_by_date')
    raise ArgumentError unless param_is_valid

    value = [].tap do |order|
      TRANSLATE_ORDER_PARAMS.select do |element|
        order << element.values.second if element.values.first == params[:order_by_date]
      end
    end

    result = if value.present?
               value.first
             else
               :desc
             end

    scope.order(date: result)
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
