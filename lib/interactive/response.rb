module Interactive
  class Response
    def initialize(*args)
      set_args(args)
      check_validity

      @_response = STDIN.gets.chomp

      define_methods
      define_invalid
    end

    private

    def check_validity
      raise ArgumentError, "wrong number of arguments (need at least two arguments)" if @args.length == 1
      raise ArgumentError, "may not use :invalid or 'invalid' as an argument. May not overwrite Interactive::Response#invalid" if @args.map(&:to_s).include?('invalid')

      raise ArgumentError, "may not have keyword options that have the same first letter." if first_chars_unique
    end

    def define_methods
      @args.each do |arg|
        define_singleton_method "#{arg}?" do
          @_response.match(/^#{arg[0]}$/i) ? true : false
        end
      end
    end

    def define_invalid
      define_singleton_method "invalid?" do
        methods(false).reject {|m| m == :invalid? }.none? {|m| send(m) }
      end
    end

    def first_chars_unique
      @args.map{|arg| arg[0]}.uniq.length != @args.length
    end

    def set_args(args)
      if args.first.respond_to?(:to_a)
        @args = args.first
      else
        @args = args
      end
    end
  end
end
