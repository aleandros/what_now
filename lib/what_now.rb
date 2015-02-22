# What_now definitions

require 'ptools'
require 'todo'

module WhatNow
  class << self

    def ignorecase
      @ignorecase = true
    end

    def search_line(line, line_number, path)
      regex = @ignorecase ? /TODO:?\s*(.+)$/i : /TODO:?\s*(.+)$/
      text = regex.match(line)
      Todo.new(text[1], line_number, path) if text
    end

    def search_file(path)
      return [] if File.binary? path
      File.open(path).each_with_index.map do |line, i|
        search_line(line, path, i+1)
      end.delete_if { |l| l.nil? }
    end

    def search_directory(pattern)
      Dir[pattern].flat_map do |file|
        search_file(file)
      end
    end
  end
end
