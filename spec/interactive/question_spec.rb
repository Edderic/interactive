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
      allow(iq).to receive(:puts).with(question_with_opts)

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
      expect(iq).to have_received(:puts).with(question_with_opts)
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
        allow(iq).to receive(:puts)

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
        expect(iq).to have_received(:puts).with(question_with_opts).twice
        expect(iq).to have_received(:puts).with(meaning_opts).once
      end
    end
  end
end
