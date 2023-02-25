# frozen_string_literal: true

class ImportExcelController < ApplicationController
  def new; end

  def create
    if params[:operations].blank? || !params[:operations].original_filename.include?('.xls')
      flash[:notice] = 'You have not selected a file or selected another format file. Try again!'
      redirect_to new_import_path
    else
      uploaded_file = params[:operations]
      file = Tempfile.new(uploaded_file.original_filename, Rails.root.join,
                          encoding: 'ascii-8bit')
      file.write(uploaded_file.read)

      CreateOperationsFromExcel.new(current_user, file.path).call
      file.close
      file.unlink
      redirect_to operations_path
    end
  end
end
