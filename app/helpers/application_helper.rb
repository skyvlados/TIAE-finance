# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def back_to_list_button(url)
    link_to 'Back to list'.html_safe, url, class: 'button is-light'
  end
end
