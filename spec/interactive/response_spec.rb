require 'spec_helper'

describe 'Interactive::Response' do
  describe 'two of the option keywords have the same first letter' do
    it 'raises an error' do
      message = "may not have keyword options that have the same first letter."
      expect{ Interactive::Response.new(:hello, :hi) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'have :whole_number as an arg' do
    it 'raises an error' do
      message = "may not use :whole_number or 'whole_number' as an argument. Private method."
      expect{ Interactive::Response.new(:yes, :whole_number) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'have :invalid as an arg' do
    it 'raises an error' do
      message = "may not use :invalid or 'invalid' as an argument. Private method."
      expect{ Interactive::Response.new(:yes, :invalid) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'with only one arg' do
    it 'raises an error' do
      message = "wrong number of arguments (need at least two arguments)."
      expect{ Interactive::Response.new(:yes) }.to raise_error(ArgumentError, message)
    end
  end

  describe 'with args :yes, :no, :cancel, :interact' do
    describe 'y is the response' do
      before do
        yes_response = double('String', chomp: 'y')
        allow(STDIN).to receive(:gets).and_return(yes_response)

        @r = Interactive::Response.new(:yes, :no, :cancel, :interact)
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
    end

    describe 'Y is the response' do
      before do
        yes_response = double('String', chomp: 'Y')
        allow(STDIN).to receive(:gets).and_return(yes_response)

        @r = Interactive::Response.new(:yes, :no, :cancel)
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

        @r = Interactive::Response.new(:yes, :no, :cancel)
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

        @r = Interactive::Response.new(:yes, :no, :cancel)
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
end
