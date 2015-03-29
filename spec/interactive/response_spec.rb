require 'spec_helper'

describe 'Interactive::Response' do
  describe 'with an empty array' do
    it 'should be invalid' do
      whatever_answer = 'Whatever'
      allow(STDIN).to receive(:gets).and_return(whatever_answer)
      response = Interactive::Response([])

      expect(response).not_to be_invalid
    end

    it 'should be valid' do
      whatever_answer = 'Whatever'
      allow(STDIN).to receive(:gets).and_return(whatever_answer)
      response = Interactive::Response([])

      expect(response).to be_valid
    end
  end
  describe 'two of the option keywords have the same first letter' do
    it 'raises an error' do
      message = "may not have keyword options that have the same first letter."
      args = Interactive::Options([:hello, :hi], nil)

      expect{ Interactive::Response(args) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'have :whole_number as an arg' do
    it 'raises an error' do
      message = "may not use :whole_number or 'whole_number' as an argument. Private method."
      args = Interactive::Options([:yes, :whole_number])
      expect{ Interactive::Response(args) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'have :invalid as an arg' do
    it 'raises an error' do
      message = "may not use :invalid or 'invalid' as an argument. Private method."
      args = Interactive::Options([:yes, :invalid])
      expect{ Interactive::Response(args) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'with args 1, 2, 3, :cancel' do
    describe '1 is the response' do
      before do
        one_response = double('String', chomp: '1')
        allow(STDIN).to receive(:gets).and_return(one_response)

        options = Interactive::Options([1, 2, 3, :cancel])
        @r = Interactive::Response(options)
      end

      it 'should be whole number 1' do
        expect(@r).to be_whole_number_1
      end

      it 'should be whole number' do
        expect(@r).to be_whole_number
      end

      it 'should not be 2' do
        expect(@r).not_to be_whole_number_2
      end

      it 'should not be 3' do
        expect(@r).not_to be_whole_number_3
      end

      it 'should not be cancel' do
        expect(@r).not_to be_cancel
      end

      it '#to_i returns 1' do
        expect(@r.to_i).to eq 1
      end
    end
  end

  describe 'with args :yes, :no, :cancel, :interact' do
    describe 'y is the response' do
      before do
        yes_response = double('String', chomp: 'y')
        allow(STDIN).to receive(:gets).and_return(yes_response)

        args = Interactive::Options([:yes, :no, :cancel, :interact])
        @r = Interactive::Response(args)
      end

      it 'is a yes' do
        expect(@r).to be_yes
      end

      it 'is not a no' do
        expect(@r).not_to be_no
      end

      it 'is not a cancel' do
        expect(@r).not_to be_cancel
      end

      it 'is not invalid' do
        expect(@r).not_to be_invalid
      end

      it 'is not a whole number' do
        expect(@r).not_to be_whole_number
      end
    end

    describe 'Y is the response' do
      before do
        yes_response = double('String', chomp: 'Y')
        allow(STDIN).to receive(:gets).and_return(yes_response)

        args = Interactive::Options([:yes, :no, :cancel])
        @r = Interactive::Response(args)
      end

      it 'is a yes' do
        expect(@r).to be_yes
      end

      it 'is not a no' do
        expect(@r).not_to be_no
      end

      it 'is not a cancel' do
        expect(@r).not_to be_cancel
      end
    end

    describe 'n is the response' do
      before do
        yes_response = double('String', chomp: 'n')
        allow(STDIN).to receive(:gets).and_return(yes_response)

        args = Interactive::Options([:yes, :no, :cancel])
        @r = Interactive::Response(args)
      end

      it 'is not a no' do
        expect(@r).to be_no
      end

      it 'is a yes' do
        expect(@r).not_to be_yes
      end

      it 'is not a cancel' do
        expect(@r).not_to be_cancel
      end
    end

    describe 'someinvalid is the response' do
      before do
        bad_response = double('String', chomp: 'someinvalid')
        allow(STDIN).to receive(:gets).and_return(bad_response)

        args = Interactive::Options([:yes, :no, :cancel])
        @r = Interactive::Response(args)
      end

      it 'is not a no' do
        expect(@r).not_to be_no
      end

      it 'is not a yes' do
        expect(@r).not_to be_yes
      end

      it 'is not a cancel' do
        expect(@r).not_to be_cancel
      end

      it 'is invalid' do
        expect(@r).to be_invalid
      end
    end
  end

  describe 'response is "hello"' do
    it 'response should be "hello"' do
      response = double('String', chomp: 'hello')
      allow(STDIN).to receive(:gets).and_return(response)

      args = Interactive::Options([:yes, :no, :cancel])
      @r = Interactive::Response(args)
      expect(@r).to eq 'hello'
    end
  end
end
