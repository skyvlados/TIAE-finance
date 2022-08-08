# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :find_user

  def find_user
    @user = User.find(params[:id])
  end
end
