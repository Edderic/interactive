require 'spec_helper'

describe 'Interactive::Question' do
  describe '#ask_and_wait_for_valid_response' do
    it 'raises an error if no question is provided' do
      question = "Which item do you want to use?"
      question_with_opts = "#{question} [y/n/c]"
      options = [:yes, :no, :cancel]

      expect do
        iq = Interactive::Question.new do |i|
          i.options = options
        end
      end.to raise_error(ArgumentError, "question cannot be nil nor empty.")
    end

    it 'raises an error if question is blank' do
      question = ""
      question_with_opts = "#{question} [y/n/c]"
      options = [:yes, :no, :cancel]

      expect do
        iq = Interactive::Question.new do |i|
          i.question = question
          i.options = options
        end
      end.to raise_error(ArgumentError, "question cannot be nil nor empty.")
    end

    it 'raises an error if options is empty' do
      question = "Do you want to go?"
      question_with_opts = "#{question} [y/n/c]"
      options = nil

      expect do
        iq = Interactive::Question.new do |i|
          i.question = question
          i.options = options
        end
      end.to raise_error(ArgumentError, "options cannot be empty.")
    end

    it 'should ask the question' do
      question = "Which item do you want to use?"
      question_with_opts = "#{question} [y/n/c]"
      options = [:yes, :no, :cancel]

      iq = Interactive::Question.new do |i|
        i.question = question
        i.options = options
      end

      yes_response = instance_double('String', chomp: 'y')
      response_spy = double('response', yes: nil, no: nil, cancel: nil)
      allow(STDIN).to receive(:gets).and_return(yes_response)
      allow_any_instance_of(QuestionWithLazyFullExplanation).to receive(:puts).with(question_with_opts)
      expect_any_instance_of(QuestionWithLazyFullExplanation).to receive(:puts).with(question_with_opts)

      iq.ask_and_wait_for_valid_response do |response|
        if response.yes?
          response_spy.yes
        elsif response.no?
          response_spy.no
        elsif response.cancel?
          response_spy.cancel
        end
      end

      expect(response_spy).to have_received(:yes)
    end

    describe 'response is invalid' do
      it 'reshows the valid options' do
        question = "Which item do you want to use?"
        question_with_opts = "#{question} [y/n/c]"
        meaning_opts = "  y -- yes\n  n -- no\n  c -- cancel\n"
        options = [:yes, :no, :cancel]

        iq = Interactive::Question.new do |i|
          i.question = question
          i.options = options
        end

        bad_response = instance_double('String', chomp: 'b')
        yes_response = instance_double('String', chomp: 'y')
        response_spy = double('response', yes: nil, no: nil, cancel: nil)
        allow(STDIN).to receive(:gets).and_return(bad_response, yes_response)
        allow_any_instance_of(QuestionWithLazyFullExplanation).to receive(:puts)
        expect_any_instance_of(QuestionWithLazyFullExplanation).to receive(:puts).with(question_with_opts).twice
        expect_any_instance_of(QuestionWithLazyFullExplanation).to receive(:puts).with(meaning_opts).once

        iq.ask_and_wait_for_valid_response do |response|
          if response.yes?
            response_spy.yes
          elsif response.no?
            response_spy.no
          elsif response.cancel?
            response_spy.cancel
          end
        end

        expect(response_spy).to have_received(:yes)
      end
    end

    it 'is able to process whole numbers' do
      response_20 = instance_double('String', chomp: '20')
      allow(STDIN).to receive(:gets).and_return(response_20)

      Interactive::Question.new do |i|
        i.question = "Which item do you want to open?"
        i.options = [1..30, :cancel]
      end.ask_and_wait_for_valid_response do |response|
        expect(response).to be_whole_number_20
        expect(response).not_to be_cancel
        expect(response).not_to be_whole_number_1
      end
    end

    it 'is able to process indexed options' do
      response_0 = instance_double('String', chomp: '0')
      indexed_options = ['/some/path', 'some/other/path']
      allow(STDIN).to receive(:gets).and_return(response_0)

      Interactive::Question.new do |i|
        i.question = "Which item do you want to open?"
        i.options = [indexed_options, :cancel]
      end.ask_and_wait_for_valid_response do |response|
        expect(response).to be_whole_number_0
        expect(response).not_to be_cancel
        expect(response).not_to be_whole_number_1
      end
    end

    it 'shows full options when given indexed options' do
      response_0 = instance_double('String', chomp: '0')
      indexed_options = ['/some/path', '/some/other/path']
      allow(STDIN).to receive(:gets).and_return(response_0)

      question = Interactive::Question.new do |i|
        i.question = "Which item do you want to open?"
        i.options = [indexed_options, :cancel]
      end

      allow_any_instance_of(QuestionWithEagerFullExplanation).to receive(:puts)
      expect_any_instance_of(QuestionWithEagerFullExplanation).to receive(:puts).with("  0 -- /some/path\n  1 -- /some/other/path\n  c -- cancel\n")

      question.ask_and_wait_for_valid_response do |response|
      end
    end
  end
end
