# frozen_string_literal: true

class CreateCategiries < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.text :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
