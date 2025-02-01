# frozen_string_literal: true

class AddTelegramIdColumnToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :telegram_id, :bigint
    add_index :users, :telegram_id, unique: true
    add_index :users, %i[telegram_id name], unique: true
    change_column_null :users, :email, true
    change_column_null :users, :password_digest, true
    remove_column :users, :email_confirmed
    remove_column :users, :confirm_token
    remove_column :users, :confirm_recovery_password_token

    User.where(id: 1).update(telegram_id: 1) unless Rails.env.production?
  end

  def down
    User.where(id: 1).update(telegram_id: nil) unless Rails.env.production?

    add_column :users, :confirm_recovery_password_token, :string, unique: true
    add_column :users, :confirm_token, :string, unique: true
    add_column :users, :email_confirmed, :boolean, default: false
    remove_column :users, :telegram_id
    change_column_null :users, :password_digest, false
    change_column_null :users, :email, false
  end
end
