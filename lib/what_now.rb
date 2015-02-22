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
    @todo_class.new(text[1], shortened_path(path), line_number) if text
  end

  private
  def shortened_path(path)
    path[Dir.pwd.length+1..path.length]
  end
end

class TodoFinder
  def initialize(pattern, creator)
    @paths = Dir[pattern].delete_if do |path|
      File.directory?(path) || File.binary?(path)
    end
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
