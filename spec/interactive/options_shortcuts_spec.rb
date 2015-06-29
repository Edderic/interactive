require 'spec_helper'

describe Interactive::OptionsShortcuts do
  describe '#minify' do
    describe 'if there is an option of numbers in the list' do
      describe 'and they are too long' do
        it 'should make condense the shortcuts smaller' do
          shortcuts = "1/2/3/4/5/6/b/c"
          options_shortcuts = Interactive::OptionsShortcuts.new(shortcuts)
          expect( options_shortcuts.minify).to eq "1..6/b/c"
        end
      end

      describe 'and there is only one number' do
        it 'should print the regular shortcut list' do
          shortcuts = "1/b/c"
          options_shortcuts = Interactive::OptionsShortcuts.new(shortcuts)
          expect( options_shortcuts.minify).to eq shortcuts
        end
      end
    end

    describe 'if there are no options of numbers in the list' do
      it 'should just print the shortcuts regularly' do
        shortcuts = "b/c"
        options_shortcuts = Interactive::OptionsShortcuts.new(shortcuts)
        expect( options_shortcuts.minify).to eq shortcuts
      end
    end
  end
end
