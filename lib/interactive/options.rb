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
      options.inject("") { |accum, opt| "#{accum}  #{opt.shortcut_value} -- #{opt}\n"}
    end

    private

    def flatten_ranges(options)
      @options = options.inject([]) {|accum, opt| opt.respond_to?(:to_a) ? accum | opt.to_a : accum << opt}
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
