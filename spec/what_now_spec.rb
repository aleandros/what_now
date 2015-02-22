require_relative 'spec_helper'

describe TodoCreator do
  describe '#match' do
    describe 'with case sensitivity' do
      subject do
        TodoCreator.new
      end

      it 'correctly extracts text from todo' do
        subject.match('TODO this is a todo', '.', 1)
          .text.must_match 'this is a todo'
      end

      it 'returns nil with a non todo line' do
        subject.match('this is not a todo', '.', 1)
          .must_be_nil
      end

      it 'returns nil in a downcase todo' do
        subject.match('todo this is not a todo', '.', 1)
          .must_be_nil
      end
    end

    describe 'with case insensitivity' do
      subject do
        TodoCreator.new ignorecase: true
      end

      it 'extracts the text from the TODO in uppercase' do
        subject.match('TODO this is a todo', '.', 1)
          .text.must_match 'this is a todo'
      end

      it 'extracts the text from the TODO in downcase' do
        subject.match('todo this is a todo', '.', 1)
          .text.must_match 'this is a todo'
      end
    end

    describe 'object type returned' do
      it 'default should be pretty' do
        TodoCreator.new.match('TODO this is a todo', '.', 1)
          .must_be_instance_of PrettyTodo
      end

      it 'non pretty can be specified' do
        TodoCreator.new(pretty: false).match('TODO this is a todo', '.', 1)
          .must_be_instance_of Todo
      end
    end
  end
end

describe TodoFinder do
  describe 'search single file' do
    subject do
      path = File.dirname(__FILE__) + '/example_file.txt'
      TodoFinder.new(path, TodoCreator.new).find
    end

    it 'found 2 todos' do
      subject.length.must_equal 2
    end

    it 'found the correct todos' do
      subject[0].text.must_match 'this is a todo'
      subject[0].line.must_equal 2
      subject[1].text.must_match 'but this is also a todo'
      subject[1].line.must_equal 5
    end
  end

  describe 'search with a pattern' do
    it 'considers only specified pattern' do
      results = TodoFinder.new(
        File.dirname(__FILE__)+'/**/*.txt',
        TodoCreator.new).find
      results.length.must_equal 2
    end

    it 'returns empty array if nothing was found' do
      results = TodoFinder.new(
        File.dirname(__FILE__)+'/**/*.mooo',
        TodoCreator.new).find
      results.must_equal []
    end
  end
end
