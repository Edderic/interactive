require 'delegate'

module Interactive
  class Options < SimpleDelegator
    include Interactive
    attr_accessor :options

    def initialize(options)
      flatten_ranges(options)
      wrap_each_option
      super(@options)
    end

    def shortcuts_string
      "[#{first_chars_without_last_slash(first_chars)}]"
    end

    def shortcuts_meanings
      options.inject("") { |accum, opt| "#{accum}  #{opt.shortcut_value} -- #{opt.value}\n"}
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
      options.inject("") { |accum, opt| "#{accum}#{ opt.shortcut_value}/" }
    end

    def first_chars_without_last_slash(first_chars)
      first_chars[0..first_chars.length-2]
    end
  end
end
