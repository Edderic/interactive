require 'delegate'

module Interactive
  module_function

  def Option(option)
    if option.respond_to?(:to_hash)
      @option = HashNumberedOption.new(option)
    elsif option.to_s.match(/^\d+$/)
      @option = WholeNumberOption.new(option)
    else
      @option = WordOption.new(option)
    end

    @option
  end

  class WholeNumberOption < SimpleDelegator
    def initialize(option)
      @option = option
      super(@option)
    end

    def shortcut_value
      @option
    end

    def query_method_name
      "whole_number_#{shortcut_value}?"
    end

    def value
      @option
    end
  end

  class WordOption < SimpleDelegator
    def initialize(option)
      @option = option
      super(@option)
    end

    def shortcut_value
      @option.to_s[0]
    end

    def query_method_name
      "#{@option}?"
    end

    def value
      @option
    end
  end

  class HashNumberedOption < SimpleDelegator
    def initialize(option)
      @option = option
      super(@option)
    end

    def shortcut_value
      @option.keys.first
    end

    def query_method_name
      "whole_number_#{shortcut_value}?"
    end

    def value
      @option[shortcut_value]
    end
  end
end
