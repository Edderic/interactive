require 'spec_helper'

describe 'Options' do
  describe '(1..3, :cancel)' do
    before do
      @options = Interactive::Options([1..3, :cancel], nil)
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

  describe 'with columns' do
    before do
      object_1 = double('some_object', name: 'hello', estimate: 2)
      object_2 = double('some_object', name: 'hi', estimate: 3)
      objects_options = [object_1, object_2]
      columns = [:index, :name, :estimate]
      @options = Interactive::Options([objects_options, :back], columns)
    end

    describe '#shortcuts_string' do
      it 'should have the indices along with first character shortcuts' do
        expect(@options.shortcuts_string).to match(/\[0\/1\/b\]/)
      end
    end

    describe '#shortcuts_meanings' do
      it 'should print out the table' do

      end

      it 'should also print out the non-tabular options' do
        expect(@options.shortcuts_meanings).to match(/b -- back/)
        expect(@options.shortcuts_meanings).to match(/index/)
        expect(@options.shortcuts_meanings).to match(/name/)
        expect(@options.shortcuts_meanings).to match(/estimate/)
        expect(@options.shortcuts_meanings).to match(/hi/)
        expect(@options.shortcuts_meanings).to match(/hello/)
      end
    end
  end
end
