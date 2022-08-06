# frozen_string_literal: true

class UserQuery
    attr_reader :params
  
    def initialize(params)
      @params = params
    end
  
    def call
      User
        .then { |scope| filter_by_name scope }
        .then { |scope| filter_by_email scope }
    end
  
    def filter_by_name(scope)
      return scope if params[:name].blank?
  
      scope.where("name LIKE ?", "%" + params[:name] + "%")
    end

    def filter_by_email(scope)
        return scope if params[:email].blank?
    
        scope.where("email LIKE ?", "%" + params[:email] + "%")
    end
  
  end
  