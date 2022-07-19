# frozen_string_literal: true

class OperationQueryDate
    attr_reader :date_start, :date_finish, :scope

    def initialize(date_start, date_finish, scope)
        @date_start = date_start
        @date_finish = date_finish
        @scope = scope
    end
  
    def call # rubocop:disable Metrics/AbcSize
        if !@date_start.present? && !@date_finish.present?
            return scope
        end
        if  @date_start.present? && @date_finish.present? 
            dateScope = scope.where('date>= ?', @date_start)
            dateScope = dateScope.where('date<= ?', @date_finish)
            return dateScope
        end
        if !@date_start.present?
            dateScope = scope.where('date<= ?', @date_finish)
            return dateScope
        end
        if !@data_finish.present?
            dateScope = scope.where('date>= ?', @date_start)
            return dateScope
        end
    end
  end
  