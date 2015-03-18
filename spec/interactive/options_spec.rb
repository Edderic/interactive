require 'spec_helper'

describe 'Options' do
  describe '(1..3, :cancel)' do
    before do
      @options = Interactive::Options([1..3, :cancel])
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

  describe '(array_of_options, :cancel)' do
    before do
      @options = Interactive::Options([["/some/path", "/some/other/path"], :cancel])
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

  describe ' (without args)' do
    before do
      @options = Interactive::Options()
    end

    it '#shortcuts_string should be empty' do
      expect(@options.shortcuts_string).to be_empty
    end

    it '#shortcuts_meanings should be empty' do
      expect(@options.shortcuts_meanings).to be_empty
    end

    it '#has_hash? should be false' do
      expect(@options).not_to be_has_hash
    end
  end
end
