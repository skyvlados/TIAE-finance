# frozen_string_literal: true

class ImportExcelController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :show_errors

  rescue_from 'MyAppError::FailedCreateCategoriesOrOperations' do |_exception|
    render status: :unprocessable_entity
  end

  def new; end

  def create
    if params[:operations].blank? || !params[:operations].original_filename.include?('.xls')
      flash[:notice] = 'You have not selected a file or selected another format file. Try again!'
      redirect_to new_import_path
    else
      WriteExcelFile.new(params[:operations], current_user).call
      flash[:notice] = 'Operations successfully saved!'
      redirect_to operations_path
    end
  end
end
