# frozen_string_literal: true

module ButtonHelper
  def button_text
    case controller.action_name
    when 'new' then 'Save'
    when 'edit' then 'Edit'
    else 'Submit'
    end
  end
end
