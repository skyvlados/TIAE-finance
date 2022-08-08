# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :find_user, only: [:index]
  def index; end
end
