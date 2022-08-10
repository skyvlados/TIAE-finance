# frozen_string_literal: true

class Session < ApplicationRecord
    validates :email, presence: true,
                      length: { minimum: 4, maximum: 254 }
    validates :password, presence: true
  end
  