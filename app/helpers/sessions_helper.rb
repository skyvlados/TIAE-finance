# frozen_string_literal: true

module SessionsHelper
  TELEGRAM_ID_FOR_DEVELOPMENT_OR_TEST_ENVIRONMENT = 1
  NAME_FOR_DEVELOPMENT_OR_TEST_ENVIRONMENT = 'admin'

  def current_user
    if Rails.env.production?
      telegram_id = Base64.decode64(cookies[:profile]).match(/id=(\d+)/)[1].to_i
      encoded_name = Base64.decode64(cookies).match(/first_name=([^&]+)/)[1]
      name = URI.decode_www_form_component(encoded_name)
    else
      telegram_id = TELEGRAM_ID_FOR_DEVELOPMENT_OR_TEST_ENVIRONMENT
      name = NAME_FOR_DEVELOPMENT_OR_TEST_ENVIRONMENT
    end

    user = User.find_by(telegram_id: telegram_id, name: name) ||
           User.create(telegram_id: telegram_id, name: name)
    @current_user ||= user
  end
end
