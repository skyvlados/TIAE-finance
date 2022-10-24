# frozen_string_literal: true

class AddConfirmTokenForRecoveryPassword < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :confirm_recovery_password_token, :string, unique: true
  end
end
