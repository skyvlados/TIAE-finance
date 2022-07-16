class OperationQuery
    FILTERS = %i[currency category direction]
    attr_reader :params

    def initialize(params)
        @params=params
    end

    def call
        scope = Operation.order(id: :asc)
        FILTERS.each do |filter|
            scope = scope.where(filter => params[filter]) if params[filter].present?
        end
        scope
    end
end