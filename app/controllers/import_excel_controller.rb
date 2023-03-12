# frozen_string_literal: true

class ImportExcelController < ApplicationController
  def new; end

  def create
    if params[:operations].blank? || !params[:operations].original_filename.include?('.xls')
      flash[:notice] = 'You have not selected a file or selected another format file. Try again!'
      redirect_to new_import_path
    else
      service = WriteExcelFile.new(params, current_user)
      service.call
      flash[:notice] = "Operations successfully saved!"
      redirect_to operations_path
    end
  end
end
