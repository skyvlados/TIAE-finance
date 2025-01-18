# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_session
  include Pagy::Backend
  include SessionsHelper

  def check_session
    current_user
  end
end
