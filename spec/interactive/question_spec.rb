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

    it 'makes #ask an alias for #ask_and_wait_for_valid_response' do
      response_20 = instance_double('String', chomp: '20')
      allow(STDIN).to receive(:gets).and_return(response_20)

      Interactive::Question.new do |i|
        i.question = "Which item do you want to open?"
        i.options = [1..30, :cancel]
      end.ask do |response|
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

    it 'can have #ask be stubbable' do
      expect do
        instance_double('Interactive::Question', ask: nil)
      end.not_to raise_error
    end
  end

  describe 'nested questions, inner one having :back as an option' do
    it 'should ask the outer question again' do
      outer_question = Interactive::Question.new do |c|
        c.question = "What would you like to do?"
        c.options = [:cook, :exercise, :vacuum]
      end

      inner_question = Interactive::Question.new do |c|
        c.question = "What do you want to cook?"
        c.options = [:spaghetti, :pad_thai, :back]
      end

      outer_response_1 = instance_double('Response', cook?: true, invalid?: false)
      outer_response_2 = instance_double('Response', cook?: false, invalid?: false)
      inner_response = instance_double('Response', back?: true, invalid?: false)

      allow(Interactive).to receive(:Response).and_return(outer_response_1, inner_response, outer_response_2)
      allow(STDIN).to receive(:gets).and_return('c', 'b', 'e')
      outer_question.ask do |outer_response|
        if outer_response.cook?
          inner_question.ask do |inner_response|
            if inner_response.back?
              outer_question.reask!
            end
          end
        end
      end

      expect(outer_response_1).to have_received(:cook?)
      expect(outer_response_2).to have_received(:cook?)
    end
  end

  describe 'table-style question' do
    it 'should display the question in a tabular fashion' do
      object_1 = instance_double('obj', story_type: 'estimate',
                                        estimate: 2,
                                        name: 'pgit story should display list of stories for the current story',
                                        status: 'unstarted')

      object_2 = instance_double('obj', story_type: 'estimate',
                                        estimate: nil,
                                        name: 'hello world',
                                        status: 'unstarted')
      columns = [:index, :story_type, :estimate, :name, :status]
      allow(STDIN).to receive(:gets).and_return('0')
      question = Interactive::Question.new do |c|
        c.question = "Which one are you interested in?"
        c.options = [[object_1, object_2], :back]
        c.columns = columns
      end

      headings = [:index, :story_type, :estimate, :name, :status]
      table_string = '| some | table |'
      table = double('table', to_s: table_string,
                              align_column: nil,
                              :<< => nil)
      allow(Terminal::Table).to receive(:new).with(headings: headings).and_return(table)
      question.ask do |r|
      end

      expect(table).to have_received(:to_s)
    end
  end
end
