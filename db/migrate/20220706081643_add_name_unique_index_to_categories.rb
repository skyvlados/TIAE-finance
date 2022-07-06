# frozen_string_literal: true

class AddNameUniqueIndexToCategories < ActiveRecord::Migration[7.0]
  def change
    add_index :categories, :name, unique: true
  end
end
