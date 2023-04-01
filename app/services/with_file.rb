# frozen_string_literal: true

class WithFile
  def initialize(io)
    @io = io
  end

  def call
    file = Tempfile.new(@io.original_filename, Rails.root.join, encoding: 'ascii-8bit')
    file.write(@io.read)
    file.close

    yield file
  ensure
    file.unlink
  end
end
