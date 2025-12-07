# frozen_string_literal: true

module Metrics
  module_function

  def setup!
    Yabeda.configure do
      group :app do
        counter :http_requests_total,
                comment: 'Count of HTTP requests',
                tags: %i[controller action]
      end
    end
  end

  def track_http(controller:, action:)
    Yabeda.app.http_requests_total.increment(
      controller: controller,
      action: action
    )
  end
end
