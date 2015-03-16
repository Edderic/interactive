module Interactive
  class Option
    def initialize(option)
      @option = option
    end

    def shortcut_value
      @option.to_s.match(/^\d+$/) ? @option : @option.to_s[0]
    end
  end
end
