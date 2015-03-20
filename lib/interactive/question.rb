require 'forwardable'

module Interactive
  class Question
    extend Forwardable
    attr_accessor :question, :options
    def_delegators :@question_type, :reask!

    def initialize(&block)
      yield self

      @options = Interactive::Options(Array(@options))

      raise ArgumentError, "question cannot be nil nor empty." if question.nil? || question.empty?
      @question_type = @options.has_hash? ? QuestionWithEagerFullExplanation.new(self) : QuestionWithLazyFullExplanation.new(self)
    end

    def ask_and_wait_for_valid_response(&block)
      @question_type.ask_and_wait_for_valid_response(&block)
    end

    def ask(&block)
      ask_and_wait_for_valid_response(&block)
    end

    private

    def response
      STDIN.gets.chomp
    end
  end
end
