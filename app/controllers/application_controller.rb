# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_session
  include Pagy::Backend
  include SessionsHelper

  def check_session
    redirect_to root_path if current_user.blank?
  end
end
