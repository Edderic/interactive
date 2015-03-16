require 'spec_helper'

describe 'Options' do
  describe '#new(1..3, :cancel)' do
    before do
      @options = Interactive::Options.new([1..3, :cancel])
    end

    it 'transforms arguments into a full array' do
      expect(@options).to include(1)
      expect(@options).to include(2)
      expect(@options).to include(3)
      expect(@options).to include(:cancel)
    end

    it 'prints the shortcuts correctly' do
      expect(@options.shortcuts_string).to eq "[1/2/3/c]"
    end

    it 'prints the meanings correctly' do
      expect(@options.shortcuts_meanings).to eq "  1 -- 1\n  2 -- 2\n  3 -- 3\n  c -- cancel\n"
    end
  end

  describe '#new(array_of_options, :cancel)' do
    before do
      @options = Interactive::Options.new([["/some/path", "/some/other/path"], :cancel])
    end

    it 'should convert the array into a hashes' do
      expect(@options.first.value).to eq '/some/path'
      expect(@options[1].value).to eq '/some/other/path'
      expect(@options[2].value).to eq :cancel
    end

    it 'prints the shortcuts correctly' do
      expect(@options.shortcuts_string).to eq "[0/1/c]"
    end

    it 'prints the meanings correctly' do
      expect(@options.shortcuts_meanings).to eq "  0 -- /some/path\n  1 -- /some/other/path\n  c -- cancel\n"
    end
  end
end
