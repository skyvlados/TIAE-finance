# frozen_string_literal: true

class ImportExcelController < ApplicationController
  def new; end

  def create
    uploaded_file = params[:operations]
    file = Tempfile.new(uploaded_file.original_filename, Rails.root.join('public', 'uploads'),
                        encoding: 'ascii-8bit')
    file.write(uploaded_file.read)

    CreateOperationsFromExcel.new(current_user, file.path).call
    redirect_to operations_path
  ensure
    file.close
    file.unlink
  end
end
