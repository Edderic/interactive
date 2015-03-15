require 'delegate'

class Options < SimpleDelegator
  attr_accessor :options

  def initialize(options)
    @options = options
    super(options)
  end

  def shortcuts_string
    "[#{first_chars_without_last_slash(first_chars)}]"
  end

  def shortcuts_meanings
    options.inject("") { |accum, opt| "#{accum}  #{opt[0]} -- #{opt}\n"}
  end

  private

  def first_chars
    options.inject("") { |accum, opt| "#{accum}#{opt[0]}/" }
  end

  def first_chars_without_last_slash(first_chars)
    first_chars[0..first_chars.length-2]
  end
end
