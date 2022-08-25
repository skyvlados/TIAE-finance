# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :check_session
  def index; end
end
