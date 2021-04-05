# frozen_string_literal: true

# This test was created simply to check how to create a double of class that doesn't 
# yet exist and then apply that class double to an instance variable of the class
# being tested. In this case, the double is of the Rack class and is applied to
# the @rack instance variable in the ConnectFour class.

require_relative '../lib/test'

describe ConnectFour do
  subject(:game) { described_class.new }

  describe '#game_won?' do
    context 'when the rack object is specifying a winner' do
      it 'returns true' do
        rack = double('rack')
        allow(rack).to receive(:winner).and_return(1)
        game.instance_variable_set(:@rack, rack)
        expect(game.game_won?).to eq(true)
      end
    end

    context 'when the rack object isn\'t specifying a winner' do
      it 'returns false' do
        rack = double('rack')
        allow(rack).to receive(:winner).and_return(0)
        game.instance_variable_set(:@rack, rack)
        expect(game.game_won?).to eq(false)
      end
    end
  end
end
