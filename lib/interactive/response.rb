module Interactive
  class Response
    def initialize(*args)
      if args.first.class.ancestors.include?(Enumerable)
        @args = args.first
      else
        @args = args
      end

      raise ArgumentError, "wrong number of arguments (need at least two arguments)" if @args.length == 1
      @_response = STDIN.gets.chomp

      @args.each do |arg|
        define_singleton_method "#{arg}?" do
          @_response.match(/^#{arg[0]}$/i) ? true : false
        end
      end

      define_singleton_method "invalid?" do
        methods(false).reject {|m| m == :invalid? }.none? {|m| send(m) }
      end
    end
  end
end
