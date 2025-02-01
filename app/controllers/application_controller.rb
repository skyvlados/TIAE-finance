# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  include Pagy::Backend

  def current_user
    if Rails.env.development?
      telegram_id = 1
      name = 'admin'
    else
      telegram_id = request.headers['Auth-User-Id']
      name = request.headers['Auth-User-First-Name']
    end

    @current_user ||= User.find_or_create_by(telegram_id: telegram_id) do |user|
      user.name = name
    end
  end
end
