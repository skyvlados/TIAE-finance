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

  def call
    # NOTE: spreadsheet only supports .xls files (not .xlsx)
    # workbook = Spreadsheet.open '/Users/vladislav/My_documents/operation.xls'
    workbook = Spreadsheet.open path_excel_file
    @worksheets = workbook.worksheets
    create_operations
  end

  def create_operations
    worksheet = @worksheets.first

    worksheet.rows.each_with_index do |row, index|
      next if index.zero? || row[OPERATION_DATE].nil?

      if Category.find_by_name(row[CATEGORY].to_s).blank?
        Category.create(name: row[CATEGORY].to_s, user_id: current_user.id)
      end

      Operation.create(
        direction: row[OPERATION_SUM].positive? ? 'income' : 'expenditure',
        date: row[OPERATION_DATE],
        amount: row[OPERATION_SUM].abs,
        user: current_user,
        category: Category.find_by_name(row[CATEGORY].to_s),
        currency: row[CURRENCY]
      )
    end
  end
end
