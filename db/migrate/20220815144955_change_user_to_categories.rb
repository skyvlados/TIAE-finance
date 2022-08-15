# frozen_string_literal: true

class ChangeUserToCategories < ActiveRecord::Migration[7.0]
  def change
    change_column_default :categories, :user_id, nil
  end
end
