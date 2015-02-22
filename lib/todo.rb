# Contains the abstractions related
# to todo's objects
require 'colorize'

class Todo
  attr_reader :text, :path, :line

  def initialize text, path, line
    @text = text
    @path = path
    @line = line
  end

  def to_s
    "#{@text} at line #{@line} in #{@path}"
  end
end

class PrettyTodo < Todo
  def to_s
    "#{@text.red.bold}\nat line #{@line.to_s.blue} in #{@path.blue.underline}"
  end
end

