# frozen_string_literal: true

class CreateOperations < ActiveRecord::Migration[7.0]
  def change
    create_table :operations do |t|
      t.integer :type
      t.belongs_to :category, foreign_key: true
      t.timestamp :date
      t.decimal :amount
      t.integer :currency

      t.timestamps
    end
  end
end
