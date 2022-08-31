# frozen_string_literal: true

class AddEmailConfirmColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :email_confirmed, :boolean, default: false
    add_column :users, :confirm_token, :string, unique: true
  end
end
