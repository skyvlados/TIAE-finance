# frozen_string_literal: true

class OperationQuery
  FILTERS = %i[currency category direction].freeze
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    scope = Operation.order(id: :asc)
    FILTERS.each do |filter|
      scope = scope.where(filter => params[filter]) if params[filter].present?
    end
    scope = scope.where("date>= ?", params[:date_start]) if params[:date_start].present?
    scope = scope.where("date<= ?", params[:date_finish]) if params[:date_finish].present?
    scope
  end
end
