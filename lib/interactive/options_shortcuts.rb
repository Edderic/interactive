module Interactive
  class OptionsShortcuts
    def initialize(minifiable_string)
      @minifiable_string = minifiable_string
    end

    def minify
      if has_only_one_number_or_none?
        @minifiable_string
      else
        non_numerical_options.inject("#{numerical_options.min}..#{numerical_options.max}") do |accum, item|
          "#{accum}/#{item}"
        end
      end
    end

    private

    def has_only_one_number_or_none?
      numerical_options.min == numerical_options.max
    end

    def numerical_options
      options.select {|option| numeric?(option)}
    end

    def non_numerical_options
      options.reject {|option| numeric?(option)}
    end

    def options
      @minifiable_string.split("/")
    end

    def numeric?(option)
      option.match(/^\d+$/)
    end
  end
end
