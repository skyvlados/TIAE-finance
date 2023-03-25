# frozen_string_literal: true

require 'spreadsheet'

class CreateOperationsFromExcel
  OPERATION_DATE = 0
  OPERATION_SUM = 4
  CURRENCY = 5
  CATEGORY = 9

  def initialize(current_user, path_excel_file)
    @current_user = current_user
    @path_excel_file = path_excel_file
  end

  attr_reader :current_user, :path_excel_file

  def worksheet
    Spreadsheet
      .then { |spreadsheet| spreadsheet.open(path_excel_file) }
      .then(&:worksheets)
      .then(&:first)
  end

  def find_category(name)
    Category.with_advisory_lock(name) do
      if Category.find_by(name: name, user_id: current_user.id).blank?
        Category.create(name: name, user_id: current_user.id)
      end
    end
  end

  def call
    # NOTE: spreadsheet only supports .xls files (not .xlsx)
    ActiveRecord::Base.transaction do
      worksheet.rows.each_with_index do |row, index|
        next if index.zero? || row[OPERATION_DATE].nil?

        category = find_category(row[CATEGORY].to_s)

        Operation.create(
          direction: row[OPERATION_SUM].positive? ? 'income' : 'expenditure',
          date: row[OPERATION_DATE],
          amount: row[OPERATION_SUM].abs,
          user: current_user,
          category: category || Category.find_by(name: row[CATEGORY].to_s, user_id: current_user.id),
          currency: row[CURRENCY]
        )
      end
    end
  end
end
