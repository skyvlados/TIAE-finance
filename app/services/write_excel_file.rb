# frozen_string_literal: true

class WriteExcelFile
  def initialize(io, current_user)
    @io = io
    @current_user = current_user
  end

  def call
    file = Tempfile.new(@io.original_filename, Rails.root.join,
                        encoding: 'ascii-8bit')
    file.write(@io.read)
    CreateOperationsFromExcel.new(@current_user, file.path).call
  ensure
    file.close
    file.unlink
  end
end
