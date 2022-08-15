# frozen_string_literal: true

class AddUserRefToCategories < ActiveRecord::Migration[7.0]
  def change
    default_user_id = User.first.try(:id)
    add_reference :categories, :user, foreign_key: true, default: default_user_id
  end
end
