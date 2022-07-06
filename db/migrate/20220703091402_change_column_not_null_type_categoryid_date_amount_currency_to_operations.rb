# frozen_string_literal: true

class ChangeColumnNotNullTypeCategoryidDateAmountCurrencyToOperations < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:operations, :type, false)
    change_column_null(:operations, :category_id, false)
    change_column_null(:operations, :date, false)
    change_column_null(:operations, :amount, false)
    change_column_null(:operations, :currency, false)
  end
end
