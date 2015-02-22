require_relative 'spec_helper'

describe Todo do
  describe 'public interface' do
    subject { Todo.new('do stuff', './stuff', 10) }
    it { subject.must_respond_to :text }
    it { subject.must_respond_to :path }
    it { subject.must_respond_to :line }
  end
end

describe WhatNow do
  describe '#search_line' do
    describe 'with case sensitivity' do
      subject do
        WhatNow.search_line('TODO this is a todo', 1, '.')
      end

      it 'correctly extracts text from todo' do
        subject.text.must_match 'this is a todo'
      end

      it 'returns nil with a non todo line' do
        WhatNow.search_line('this is not a todo', 1, '.')
          .must_be_nil
      end

      it 'returns nil in a downcase todo' do
        WhatNow.search_line('todo this is not a todo', 1, '.')
          .must_be_nil
      end
    end

    describe 'with case insensitivity' do
      before do
        WhatNow.ignorecase
      end

      it 'extracts the text from the TODO in uppercase' do
        WhatNow.search_line('TODO this is a todo', 1, '.')
          .text.must_match 'this is a todo'
      end

      it 'extracts the text from the TODO in downcase' do
        WhatNow.search_line('todo this is a todo', 1, '.')
          .text.must_match 'this is a todo'
      end
    end
  end

  describe '#search_file' do
    subject do
      path = File.dirname(__FILE__) + '/example_file.txt'
      WhatNow.search_file(path)
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

  describe '#search_directory' do
    it 'considers only specified pattern' do
      results = WhatNow.search_directory(File.dirname(__FILE__)+'/**/*.txt')
      results.length.must_equal 2
    end

    it 'returns empty array if nothing was found' do
      results = WhatNow.search_directory(File.dirname(__FILE__)+'/**/*.mooo')
      results.must_equal []
    end
  end
end
