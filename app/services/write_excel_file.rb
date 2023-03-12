# frozen_string_literal: true

class WriteExcelFile

    def initialize(params, current_user)
        @params = params
        @current_user = current_user
    end

    def call
        uploaded_file = @params[:operations]
        file = Tempfile.new(uploaded_file.original_filename, Rails.root.join,
                          encoding: 'ascii-8bit')
        file.write(uploaded_file.read)
        CreateOperationsFromExcel.new(@current_user, file.path).call
        ensure
            file.close
            file.unlink
    end
end
