# frozen_string_literal: true

module Loginable
  def login_as(user)
    post login_path, params: { session: { email: user.email, password: 'password' } }
  end
end
