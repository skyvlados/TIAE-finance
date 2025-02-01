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
      .then { |scope| filter_by_telegram_id scope }
      .then { |scope| order_id_desc scope }
  end

  def only_not_deleted_user(scope)
    scope.where(is_deleted: false)
  end

  def filter_by_name(scope)
    return scope if params[:name].blank?

    scope.where('name ILIKE ?', "%#{params[:name]}%")
  end

  def filter_by_telegram_id(scope)
    return scope if params[:telegram_id].blank?

    scope.where(telegram_id: params[:telegram_id])
  end

  def order_id_desc(scope)
    scope.order(id: :desc)
  end
end
