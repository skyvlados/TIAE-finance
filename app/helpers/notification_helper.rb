# frozen_string_literal: true

module NotificationHelper
  def notification_text
    case flash.first[0]
    when 'error' then 'is-danger'
    when 'info' then 'is-warning'
    when 'notice' then 'is-success'
    else ''
    end
  end
end
