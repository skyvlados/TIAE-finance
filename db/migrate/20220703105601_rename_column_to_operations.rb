# frozen_string_literal: true

class RenameColumnToOperations < ActiveRecord::Migration[7.0]
  def change
    rename_column :operations, :type, :direction
  end
end
