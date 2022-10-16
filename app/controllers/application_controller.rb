# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_session,
                except: %i[confirm_email forgot_password password_recovery set_new_password_form set_new_password]
  include Pagy::Backend
  include SessionsHelper

  def check_session
    if current_user.blank?
      flash[:notice] = 'First of all you must authorization!'
      redirect_to root_path
    end
  end
end
