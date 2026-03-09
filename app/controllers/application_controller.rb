# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  include Pagy::Backend

  private

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

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  def page_size(page_size)
    if page_size.present?
      page_size.to_i
    else
      mobile_device? ? 5 : 10
    end
  end
end
