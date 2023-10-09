# frozen_string_literal: true

class ImportExcelController < ApplicationController
  def new; end

  def create
    if file.present? && file.original_filename.include?('.xls')

      WithFile.new(file).call do |file|
        CreateOperationsFromExcel.new(current_user, file.path).call
      end

      flash[:notice] = 'Operations successfully saved!'
      redirect_to operations_path(**JSON.parse(cookies[:operations_filters]))
    else
      flash[:info] = 'You have not selected a file or selected another format file. Try again!'
      redirect_to new_import_path
    end
  end

  def file
    params[:file]
  end
end
