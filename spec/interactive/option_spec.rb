require 'spec_helper'

describe 'Interactive::Option' do
  describe '(3)' do
    before { @option = Interactive::Option(3) }

    it 'should act as an integer' do
      expect(@option + 5).to eq 8
    end

    describe '#shortcut_value' do
      it 'should return 3' do
        option = Interactive::Option(3)
        expect(option.shortcut_value).to eq 3
      end
    end
  end

  describe '(:item)' do
    describe '#shortcut_value' do
      it 'should return "i"' do
        option = Interactive::Option(:item)
        expect(option.shortcut_value).to eq 'i'
      end
    end

    it 'should act as a symbol' do
      option = Interactive::Option(:item)
      expect(option.to_s).to eq 'item'
    end
  end
end
