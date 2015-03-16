module Interactive
  class Question
    attr_accessor :question, :options

    def initialize(&block)
      yield self

      @options = Interactive::Options.new(Array(@options))

      raise ArgumentError, "question cannot be nil nor empty." if question.nil? || question.empty?
      raise ArgumentError, "options cannot be empty." if options.empty?
    end

    def ask_and_wait_for_valid_response(&block)
      loop do
        puts "#{question} #{options.shortcuts_string}"
        resp = Interactive::Response.new(options)
        puts options.shortcuts_meanings if resp.invalid?

        yield resp
        break unless resp.invalid?
      end
    end

    private

    def response
      STDIN.gets.chomp
    end
  end
end
