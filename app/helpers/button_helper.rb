# frozen_string_literal: true

module ButtonHelper
  def button_text
    case controller.action_name
    when 'new' then 'Save'
    when 'edit' then 'Edit'
    when 'forgot_password' then 'Sent instruction to email'
    when 'password_recovery' then 'Set new password'
    else 'Submit'
    end
  end
end
