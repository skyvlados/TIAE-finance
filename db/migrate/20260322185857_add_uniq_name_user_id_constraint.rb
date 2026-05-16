# frozen_string_literal: true

class AddUniqNameUserIdConstraint < ActiveRecord::Migration[7.0]
  def change
    add_index :categories, %i[name user_id], unique: true
  end
end
