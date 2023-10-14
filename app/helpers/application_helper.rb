# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def url_category_parameters
    { page: cookies[:page], page_size: cookies[:page_size] }
  end
end
