# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/connect_four'
require_relative '../lib/rack'

describe ConnectFour do
  subject(:game) { described_class.new }
  let(:rack) { instance_double(Rack) }

  describe '#game_won?' do
    context 'when the rack object is specifying a winner' do
      before do
        allow(rack).to receive(:winner).and_return(1)
        game.instance_variable_set(:@rack, rack)
      end

      it 'returns true' do
        expect(game.game_won?).to eq(true)
      end
    end

    context 'when the rack object isn\'t specifying a winner' do
      before do
        allow(rack).to receive(:winner).and_return(0)
        game.instance_variable_set(:@rack, rack)
      end

      it 'returns false' do
        expect(game.game_won?).to eq(false)
      end
    end
  end

  describe '#play_round' do
    context 'when a player makes a valid play' do
      before do
        allow(rack).to receive(:draw)
        allow(rack).to receive(:place_piece).and_return(:play_complete)
        allow(game).to receive(:request_play)
        game.instance_variable_set(:@rack, rack)
      end

      it 'does not request the same player to repeat their choice' do
        player_number = 1
        expect(game).not_to receive(:repeat_play).with(player_number, :play_complete)
        game.play_round(player_number)
      end
    end

    context 'when a player makes an invalid play' do
      before do
        allow(rack).to receive(:draw)
        allow(rack).to receive(:place_piece).and_return(:no_place)
        allow(game).to receive(:request_play)
        game.instance_variable_set(:@rack, rack)
      end

      it 'requests the same player to repeat their choice' do
        player_number = 1
        expect(game).to receive(:repeat_play).with(player_number, :no_place)
        game.play_round(player_number)
      end
    end
  end

  describe '#repeat_play' do
    context 'when the player has tried to place a piece in a full column' do
      player_number = 1
      before do
        allow(game).to receive(:play_round).with(player_number)
        allow(game).to receive(:puts).with("\n")
      end

      it 'provides an appropriate error message' do
        play = :no_place
        error_message = "\e[31mSorry, there's no more space in that column, please select another...\e[0m"
        expect(game).to receive(:puts).with(error_message)
        game.repeat_play(player_number, play)
      end
    end

    context 'when the player has tried to place a piece in a column that doesn\'t exist' do
      player_number = 1
      before do
        allow(game).to receive(:play_round).with(player_number)
        allow(game).to receive(:puts).with("\n")
      end

      it 'provides an appropriate error message' do
        play = :any_old_symbol
        error_message = "\e[31mSorry, that column doesn't exist, please select one that does...\e[0m"
        expect(game).to receive(:puts).with(error_message)
        game.repeat_play(player_number, play)
      end
    end
  end
end
