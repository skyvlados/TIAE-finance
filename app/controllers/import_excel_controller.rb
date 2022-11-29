# frozen_string_literal: true

class ImportExcelController < ApplicationController
    def create
        CreateOperationsFromExcel.new(current_user, '/Users/vladislav/My_documents/operation2.xls').call
        redirect_to operations_path
    end
  end
  