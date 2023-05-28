# frozen_string_literal: true

class OperationQuery
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    Operation
      .then { |scope| filter_by_currency scope }
      .then { |scope| filter_by_direction scope }
      .then { |scope| filter_by_category scope }
      .then { |scope| filter_by_dates scope }
      .then { |scope| order scope }
  end

  def order(scope)
    scope.order(date: :desc)
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
