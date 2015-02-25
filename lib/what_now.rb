# What_now definitions

require 'ptools'
require 'todo'

class TodoCreator
  def initialize(opts={})
    pretty = opts.fetch(:pretty, true)
    @ignorecase = opts[:ignorecase]
    @todo_class = pretty ? PrettyTodo : Todo
  end

  def match(line, path, line_number)
    regex = @ignorecase ? /TODO:?\s*(.+)$/i : /TODO:?\s*(.+)$/
    text = regex.match(line)
    @todo_class.new(text[1], path, line_number) if text
  rescue ArgumentError
    nil
  end
end

class TodoFinder
  def initialize(paths, creator)
    @paths = paths
    @creator = creator
  end

  def find
    @paths.flat_map { |file| search_file(file) }
  end

  private
  def search_file(path)
    File.open(path).each_with_index.map do |line, i|
      @creator.match(line, path, i+1)
    end.delete_if { |l| l.nil? }
  end
end
