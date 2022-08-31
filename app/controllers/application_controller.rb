# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_session, except: [:confirm_email]
  include Pagy::Backend
  include SessionsHelper

  def check_session
    if current_user.blank?
      flash[:notice] = 'First of all you must authorization!'
      redirect_to root_path
    end
  end
end
