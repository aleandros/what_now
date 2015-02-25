require_relative 'spec_helper'
require 'pathname'
require 'fileutils'
require 'fakefs/safe'

module FakeFS
  class File
    def self.binary? file
      file == '/sample/d2/f3'
    end
  end
end

FileFilter = Filtering::Filter

describe FileFilter do
  subject do
    FileFilter.new do |file|
      true
    end
  end

  describe 'public interface' do
    it 'must respond to apply' do
      subject.must_respond_to :apply
    end

    it 'must respond to chain' do
      subject.must_respond_to :chain
    end

    it 'must respond to filter' do
      subject.must_respond_to :filter
    end
  end

  describe '#apply' do
    it 'is expected to return result of predicate' do
      subject.apply(nil).must_equal true
    end
  end

  describe '#chain' do
    subject do
      FileFilter.new do |x|
        x > 0
      end.chain do |x|
        x % 2 == 0
      end
    end

    it 'returns an instance of FileFilter' do
      subject.must_be_instance_of FileFilter
    end

    it 'applies all filters when called' do
      subject.filter([-2, -1, 0, 1, 2, 3, 4]).must_equal [2, 4]
    end

    describe 'with no arguments' do
      it 'raises an exception' do
        proc do
          FileFilter.new do
            true
          end.chain
        end.must_raise ArgumentError
      end
    end

    describe 'with instance of filter' do
      subject  do
        f1 = FileFilter.new do |f|
          f % 2 == 0
        end
        FileFilter.new do |f|
          f > 0
        end.chain f1
      end

      it 'returns an instance of Filter' do
        subject.chain(FileFilter.new { |x| x > 0 }).must_be_instance_of FileFilter
      end

      it 'applies all filters when called' do
        [-2, -1, 0, 1, 2, 3, 4].keep_if do |n|
          subject.apply(n)
        end.must_equal [2, 4]
      end
    end
  end

  describe '#filter' do
    subject do
      FileFilter.new do |x|
        x > 2
      end
    end

    it 'correctly filters the elements' do
      subject.filter([-2, -1, 0, 1, 2, 3, 4]).must_equal [3, 4]
    end
  end
end

describe 'specific filters' do
  before do
    FakeFS.activate!
    FileUtils.mkdir_p 'sample/d1'
    FileUtils.mkdir_p 'sample/d2'
    FileUtils.touch 'sample/d1/f1.rb'
    FileUtils.touch 'sample/d1/f2_rb'
    FileUtils.touch 'sample/d2/f3'
  end

  after do
    FakeFS.deactivate!
  end

  let :paths do
    Dir['sample/**/*']
  end

  describe 'directory filter' do
    subject do
      Filtering::NoDirectories
    end

    it 'only returns files' do
      subject.filter(paths).sort!.must_equal ['/sample/d1/f1.rb', '/sample/d1/f2_rb', '/sample/d2/f3'].sort!
    end
  end

  describe 'binary filter' do
    subject do
      Filtering::NoBinaries
    end

    it 'only returns non-binaries' do
      subject.filter(paths).wont_include '/sample/d2/f3'
    end
  end

  describe 'directory filter' do
    subject do
      Filtering::OnlyDirectory.new '/sample/d1'
    end

    it 'only returns elements in given subdirectory' do
      subject.filter(paths).sort!.must_equal ['/sample/d1', '/sample/d1/f1.rb', '/sample/d1/f2_rb'].sort!
    end
  end

  describe 'extension filter' do
    subject do
      Filtering::OnlyExtension.new 'rb'
    end

    it 'only returns elements with the given extension' do
      subject.filter(paths).sort!.must_equal ['/sample/d1/f1.rb']
    end

    it 'still returns extension when extension specified with dot' do
      Filtering::OnlyExtension.new('.rb').filter(paths).must_equal ['/sample/d1/f1.rb']
    end

    it 'does not match a file that ends with same letter as extension' do
      subject.filter(paths).wont_include '/sample/d1/f2_rb'
    end

    it 'treats the extension case insensitively' do
      Filtering::OnlyExtension.new('RB').filter(paths).must_equal ['/sample/d1/f1.rb']
    end
  end

  describe 'regex filter' do
    subject do
      Filtering::MatchRegex.new(/f[0-9]/)
    end

    it 'only returns elements that match regular expression' do
      subject.filter(paths).sort!.must_equal ['/sample/d1/f1.rb', '/sample/d1/f2_rb', '/sample/d2/f3'].sort!
    end

    it 'accepts a string as a regular expression' do
      Filtering::MatchRegex.new('f[0-9]').filter(paths).sort!.must_equal ['/sample/d1/f1.rb', '/sample/d1/f2_rb', '/sample/d2/f3'].sort!
    end
  end
end
