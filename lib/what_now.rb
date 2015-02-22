# What_now definitions

require 'ptools'

Todo = Struct.new :text, :path, :line

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
      todos = []
      unless File.binary?(path)
        File.open(path).each_with_index do |line, i|
          result = search_line(line, path, i+1)
          todos << result if result
        end
      end
      todos
    end

    def search_directory(pattern)
      todos = []
      Dir[pattern].each do |file|
        todos = todos + search_file(file)
      end
      todos
    end
  end
end
