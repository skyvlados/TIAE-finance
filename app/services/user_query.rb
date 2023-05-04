# frozen_string_literal: true

class UserQuery
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    User
      .then { |scope| only_not_deleted_user scope }
      .then { |scope| filter_by_name scope }
      .then { |scope| filter_by_email scope }
      .then { |scope| order_id_desc scope }
  end

  def only_not_deleted_user(scope)
    scope.where(is_deleted: false)
  end

  def filter_by_name(scope)
    return scope if params[:name].blank?

    scope.where('name ILIKE ?', "%#{params[:name]}%")
  end

  def filter_by_email(scope)
    return scope if params[:email].blank?

    scope.where('email ILIKE ?', "%#{params[:email]}%")
  end

  def order_id_desc(scope)
    scope.order(id: :desc)
  end
end
