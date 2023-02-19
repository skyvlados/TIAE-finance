require 'spreadsheet'

class CreateOperationsFromExcel
    OPERATION_DATE = 0
    OPERATION_SUM = 4
    CURRENCY = 5
    CATEGORY = 9

    def initialize(current_user, path_excel_file)
        @current_user = current_user,
        @path_excel_file = path_excel_file
    end

    attr_reader :current_user, :path_excel_file

    def call
        # Note: spreadsheet only supports .xls files (not .xlsx)
        # workbook = Spreadsheet.open '/Users/vladislav/My_documents/operation.xls'
        workbook = Spreadsheet.open path_excel_file
        @worksheets = workbook.worksheets
        create_operations
    end

    def create_operations
        worksheet = @worksheets[0]

        worksheet.rows.each_with_index do |row, index|
            
            row_cells = row.to_a.map{ |v| v.methods.include?(:value) ? v.value : v }
            if index == 0 || row_cells[OPERATION_DATE] == nil
                next
            end

            if Category.find_by_name(row_cells[CATEGORY].to_s).blank?
                Category.create(name: row_cells[CATEGORY].to_s, user_id: current_user[0].id)
                category_id = Category.find_by_name(row_cells[CATEGORY].to_s).id
            else
                category_id = Category.find_by_name(row_cells[CATEGORY].to_s).id
            end
            Operation.create(
                direction: row[OPERATION_SUM].positive? ? "income" : "expenditure",
                date: row[OPERATION_DATE],
                amount: row[OPERATION_SUM].abs,
                user_id: current_user[0].id,
                category_id: category_id,
                currency: row[CURRENCY],
            )
        end
    end
end
