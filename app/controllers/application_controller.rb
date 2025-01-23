# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  include Pagy::Backend

  def current_user
    if Rails.env.production?
      telegram_id = headers['Auth-User-Id']
      name = headers['Auth-User-First-Name']
    else
      telegram_id = 1
      name = 'admin'
    end

    user = User.find_by(telegram_id: telegram_id) ||
           User.create(telegram_id: telegram_id, name: name)
    @current_user ||= user
  end
end
