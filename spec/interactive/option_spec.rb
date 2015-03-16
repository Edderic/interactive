require 'spec_helper'

describe 'Interactive::Option' do
  describe '#new(3)' do
    describe '#shortcut_value' do
      it 'should return 3' do
        option = Interactive::Option.new(3)
        expect(option.shortcut_value).to eq 3
      end
    end
  end

  describe '#new(:item)' do
    describe '#shortcut_value' do
      it 'should return "i"' do
        option = Interactive::Option.new(:item)
        expect(option.shortcut_value).to eq 'i'
      end
    end
  end
end
