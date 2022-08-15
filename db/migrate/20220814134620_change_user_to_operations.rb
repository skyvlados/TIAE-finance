# frozen_string_literal: true

class ChangeUserToOperations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :operations, :user_id, nil
  end
end
