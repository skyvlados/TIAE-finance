# frozen_string_literal: true

class OperationQueryDate
  attr_reader :date_start, :date_finish, :scope

  def initialize(date_start, date_finish, scope)
    @date_start = date_start
    @date_finish = date_finish
    @scope = scope
  end

  def call
    return scope if !@date_start.present? && !@date_finish.present?

    if @date_start.present? && @date_finish.present?
      date_scope = scope.where('date>= ?', @date_start)
      date_scope = date_scope.where('date<= ?', @date_finish)
      return date_scope
    end
    unless @date_start.present?
      date_scope = scope.where('date<= ?', @date_finish)
      return date_scope
    end
    scope.where('date>= ?', @date_start) unless @data_finish.present?
  end
end
