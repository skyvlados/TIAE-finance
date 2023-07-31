# frozen_string_literal: true

class AddOperationsComment < ActiveRecord::Migration[7.0]
  def change
    add_column :operations, :comment, :string
  end
end
