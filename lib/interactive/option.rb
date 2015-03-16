require 'delegate'

module Interactive
  module_function

  def Option(option)
    if option.to_s.match(/^\d+$/)
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
  end
end
