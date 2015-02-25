# Module for handling filtering of
# files

require 'ptools'
require 'pathname'

module Filtering
  class Filter
    attr_reader :predicates

    def initialize &predicate
      @predicates = [predicate]
    end

    def apply file
      @predicates.reduce(true) do |result, p|
        result && p.call(file)
      end
    end

    def chain other=nil
      raise ArgumentError if (not other and not block_given?)
      @predicates += other.predicates if other
      @predicates << Proc.new if block_given?
      self
    end

    def filter files
      files.keep_if do |f|
        self.apply f
      end
    end
  end

  NoDirectories = Filter.new do |path|
    not File.directory? path
  end

  NoBinaries = Filter.new do |path|
    not File.binary? path
  end

  class OnlyDirectory <  Filter
    def initialize subdirectory
      base = Pathname.new(subdirectory).expand_path.to_s
      @predicates = []
      @predicates << proc do |path|
        file = Pathname.new(path).expand_path.to_s
        file.start_with? base
      end
    end
  end

  class OnlyExtension < Filter
    def initialize ext
      extension = ext.start_with?('.') ? ext[1..-1] : ext
      @predicates = []
      @predicates << proc do |path|
        path.match(/\.#{extension}$/i) ? true : false
      end
    end
  end

  class MatchRegex < Filter
    def initialize regex
      @predicates = []
      @predicates << proc do |path|
        path.match(regex) ? true : false
      end
    end
  end
end

