module Interactive
  class Question
    attr_accessor :question, :options

    def initialize(&block)
      yield self
    end

    def ask_and_wait_for_valid_response(&block)
      resp = NullResponse.new

      while resp.invalid? do
        puts "#{question} #{shortcuts_string}"
        resp = Interactive::Response.new(options)
        puts shortcuts_meanings if resp.invalid?

        yield resp
      end
    end

    class NullResponse
      def invalid?
        true
      end
    end

    private

    def response
      STDIN.gets.chomp
    end

    def shortcuts_meanings
      options.inject("") { |accum, opt| "#{accum}  #{opt[0]} -- #{opt}\n"}
    end

    def options_first_chars
      options.inject("") { |accum, opt| "#{accum}#{opt[0]}/" }
    end

    def shortcuts_string
      "[#{options_first_chars_without_last_slash(options_first_chars)}]"
    end

    def options_first_chars_without_last_slash(options_first_chars)
      options_first_chars[0..options_first_chars.length-2]
    end
  end
end
