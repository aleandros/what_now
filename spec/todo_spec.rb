require_relative 'spec_helper'
require 'colorize'

describe Todo do
  subject { Todo.new('do stuff', './stuff', 10) }

  describe 'public interface' do
    it { subject.must_respond_to :text }
    it { subject.must_respond_to :path }
    it { subject.must_respond_to :line }
  end

  describe '#to_s' do
    it 'should respond with a simple task description' do
      subject.to_s.must_equal "do stuff at line 10 in ./stuff"
    end
  end
end

describe PrettyTodo do
  subject { PrettyTodo.new('do stuff', './stuff', 10) }

  it 'shoul be a Todo' do
    subject.must_be_kind_of Todo
  end

  it 'correctly formats the output' do
    output = subject.text.red.bold + "\n"
    output += "at line #{subject.line.to_s.blue} in #{subject.path.blue.underline}"
    subject.to_s.must_equal output
  end
end

