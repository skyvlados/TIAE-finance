class RenameColumnToOperations < ActiveRecord::Migration[7.0]
  def change
      rename_column :operations, :type, :categories_type
  end
end
