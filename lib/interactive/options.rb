require 'delegate'
require 'interactive'

module Interactive
  module_function
  def Options(options=[])
    options.empty? ? EmptyOptions.new([]) : NonEmptyOptions.new(options)
  end

  class NonEmptyOptions < SimpleDelegator
    include Interactive
    def initialize(options)
      @options = options
      flatten_ranges(@options)
      wrap_each_option
      super(@options)
    end

    def shortcuts_string
      "[#{first_chars_without_last_slash(first_chars)}]"
    end

    def shortcuts_meanings
      @options.inject("") { |accum, opt| "#{accum}  #{opt.shortcut_value} -- #{opt.value}\n"}
    end

    def has_hash?
      @options.any? {|opt| opt.respond_to?(:to_hash) }
    end

    private

    def flatten_ranges(options)
      @options = options.inject([]) do |accum, opt|
        if opt.class == Range
          accum | opt.to_a
        elsif opt.respond_to?(:to_a)
          accum | opt.map.with_index {|item, index| {index.to_s => item} }
        else
          accum << opt
        end
      end
    end

    def wrap_each_option
      @options.map! {|option| Option(option) }
    end

    def first_chars
      @options.inject("") { |accum, opt| "#{accum}#{ opt.shortcut_value}/" }
    end

    def first_chars_without_last_slash(first_chars)
      first_chars[0..first_chars.length-2]
    end
  end


  class EmptyOptions < SimpleDelegator
    def initialize(options)
      @options = options
      super(@options)
    end

    def shortcuts_string
      ''
    end

    def shortcuts_meanings
      ''
    end

    def has_hash?
      false
    end
  end
end
