# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/rack'
require_relative '../lib/slot'

describe Rack do
  red_piece = "\e[31m\u278A\e[0m"
  yellow_piece = "\e[33m\u278B\e[0m"

  subject(:rack) { described_class.new }

  describe '#initialize' do
    it 'creates an array of 7 columns of slot objects' do
      columns = rack.instance_variable_get(:@columns)
      expect(columns.length).to eq(7)
    end

    it 'the first column number is equal to 1 (not zero)' do
      columns = rack.instance_variable_get(:@columns)
      expect(columns[0][0].column).to eq(1)
    end
  end

  describe '#setup_column' do
    it 'returns a numbered column of 6 slots' do
      column = 0
      expect(rack.setup_column(column).length).to eq(6)
    end

    it 'the first row number is equal to 1 (not zero)' do
      column = 0
      expect(rack.setup_column(column)[0].row).to eq(1)
    end
  end

  describe '#draw_row' do
    context 'when the rack is first created' do
      before do
        allow(rack).to receive(:print).with('  ')
      end

      it 'draws an empty row like so... |  |  |  |  |  |  |  |' do
        output_row = '|  '
        output_row_end = "|  |\n"
        expect(rack).to receive(:print).with(output_row).exactly(6).times
        expect(rack).to receive(:print).with(output_row_end).once
        rack.draw_row(1)
      end
    end

    context 'when player 1 places a piece in row 1' do
      before do
        columns = rack.instance_variable_get(:@columns)
        columns[0][1].control = 1
        allow(rack).to receive(:print).with('  ')
      end

      it "draws the row like so... |#{red_piece} |  |  |  |  |  |  |" do
        output_row_p1 = "|#{red_piece} "
        output_row = '|  '
        output_row_end = "|  |\n"
        expect(rack).to receive(:print).with(output_row_p1).once
        expect(rack).to receive(:print).with(output_row).exactly(5).times
        expect(rack).to receive(:print).with(output_row_end).once
        rack.draw_row(1)
      end
    end

    context 'when player 1 places a piece in column 1 and then player 2 places a piece in column 2' do
      before do
        columns = rack.instance_variable_get(:@columns)
        columns[0][1].control = 1
        columns[1][1].control = 2
        allow(rack).to receive(:print).with('  ')
      end

      it "draws the row like so... |#{red_piece} |#{yellow_piece} |  |  |  |  |  |" do
        output_row_p1 = "|#{red_piece} "
        output_row_p2 = "|#{yellow_piece} "
        output_row = '|  '
        output_row_end = "|  |\n"
        expect(rack).to receive(:print).with(output_row_p1).once
        expect(rack).to receive(:print).with(output_row_p2).once
        expect(rack).to receive(:print).with(output_row).exactly(4).times
        expect(rack).to receive(:print).with(output_row_end).once
        rack.draw_row(1)
      end
    end
  end

  describe '#find_max_row' do
    context 'when the column is empty' do
      it 'returns the integer value of 6' do
        columns = rack.instance_variable_get(:@columns)
        focus_column = columns[0]
        expect(rack.find_max_row(focus_column)).to eq(6)
      end
    end

    context 'when a player has placed one piece in the column' do
      it 'returns the integer value of 5' do
        columns = rack.instance_variable_get(:@columns)
        columns[0][5].control = 1
        focus_column = columns[0]
        expect(rack.find_max_row(focus_column)).to eq(5)
      end
    end

    context 'when players have placed two pieces in the column' do
      it 'returns the integer value of 4' do
        columns = rack.instance_variable_get(:@columns)
        columns[0][5].control = 1
        columns[0][4].control = 2
        focus_column = columns[0]
        expect(rack.find_max_row(focus_column)).to eq(4)
      end
    end

    context 'when players have placed filled the column with pieces' do
      it 'returns the integer value of 0' do
        columns = rack.instance_variable_get(:@columns)
        columns[0][5].control = 1
        columns[0][4].control = 2
        columns[0][3].control = 1
        columns[0][2].control = 1
        columns[0][1].control = 2
        columns[0][0].control = 1
        focus_column = columns[0]
        expect(rack.find_max_row(focus_column)).to eq(0)
      end
    end
  end

  describe '#place_piece' do
    context 'when there is no more space in the column' do
      it 'returns the symbol :no_place' do
        columns = rack.instance_variable_get(:@columns)
        columns[0][5].control = 1
        columns[0][4].control = 2
        columns[0][3].control = 1
        columns[0][2].control = 1
        columns[0][1].control = 2
        columns[0][0].control = 1
        expect(rack.place_piece(1, 1)).to eq(:no_place)
      end
    end

    context 'when the player specifies a column number that is too big' do
      it 'returns the symbol :out_of_range' do
        expect(rack.place_piece(1, 9)).to eq(:out_of_range)
      end
    end

    context 'when the player specifies a column number that is too small' do
      it 'returns the symbol :out_of_range' do
        expect(rack.place_piece(1, 0)).to eq(:out_of_range)
      end
    end

    context 'when the player specifies a column that doesn\'t exist' do
      it 'returns the symbol :out_of_range' do
        expect(rack.place_piece(1, 'a')).to eq(:out_of_range)
      end
    end
  end

  describe '#find_adjacents' do
    context 'when there are only two friendly pieces below the piece just played'
    it 'returns [1, 1, 1]' do
      columns = rack.instance_variable_get(:@columns)
      columns[0][5].control = 1
      columns[0][4].control = 1
      played_slot = columns[0][3]
      played_slot.control = 1
      adjacents_ref = 4 # Relates to set adjacents array in 'slot.rb'
      expect(rack.find_adjacents(played_slot, [played_slot.control], adjacents_ref, true)).to eq([1, 1, 1])
    end

    context 'when there are three friendly pieces to the top right of the piece just played'
    it 'returns [1, 1, 1, 0, 0, 0]' do
      columns = rack.instance_variable_get(:@columns)
      columns[1][4].control = 1
      columns[2][3].control = 1
      played_slot = columns[0][5]
      played_slot.control = 1
      adjacents_ref = 1 # Relates to set adjacents array in 'slot.rb'
      expect(rack.find_adjacents(played_slot, [played_slot.control], adjacents_ref, true)).to eq([1, 1, 1, 0, 0, 0])
    end
  end

  describe '#winning_string' do
    context 'when checking for friends vertically' do
      context 'when there are only two friendly pieces below the piece just played' do
        it 'returns false' do
          columns = rack.instance_variable_get(:@columns)
          columns[0][5].control = 1
          columns[0][4].control = 1
          played_slot = columns[0][3]
          expect(rack.winning_string?(1, played_slot, :vertical)).to eq(false)
        end
      end

      context 'when there are only no friendly pieces below the piece just played' do
        it 'returns false' do
          columns = rack.instance_variable_get(:@columns)
          columns[0][5].control = 2
          columns[0][4].control = 2
          played_slot = columns[0][3]
          expect(rack.winning_string?(1, played_slot, :vertical)).to eq(false)
        end
      end

      context 'when the piece just played is at the bottom of the rack' do
        it 'returns false' do
          columns = rack.instance_variable_get(:@columns)
          played_slot = columns[0][5]
          expect(rack.winning_string?(1, played_slot, :vertical)).to eq(false)
        end
      end

      context 'when there are three friendly pieces below the piece just played' do
        it 'returns true' do
          columns = rack.instance_variable_get(:@columns)
          columns[0][5].control = 1
          columns[0][4].control = 1
          columns[0][3].control = 1
          columns[0][2].control = 1
          played_slot = columns[0][2]
          expect(rack.winning_string?(1, played_slot, :vertical)).to eq(true)
        end
      end
    end

    context 'when checking for friends horizontally' do
      context 'when only two pieces to the right are friendly' do
        it 'returns false' do
          columns = rack.instance_variable_get(:@columns)
          columns[0][5].control = 1
          columns[1][5].control = 1
          columns[2][5].control = 1
          columns[3][5].control = 2
          played_slot = columns[0][5]
          expect(rack.winning_string?(1, played_slot, :horizontal)).to eq(false)
        end
      end

      context 'when only three pieces to the right are friendly' do
        it 'returns true' do
          columns = rack.instance_variable_get(:@columns)
          columns[1][5].control = 1
          columns[2][5].control = 1
          columns[3][5].control = 1
          columns[0][5].control = 1
          played_slot = columns[0][5]
          expect(rack.winning_string?(1, played_slot, :horizontal)).to eq(true)
        end
      end

      context 'when two pieces to the right and one piece to the left are friendly' do
        it 'returns true' do
          columns = rack.instance_variable_get(:@columns)
          columns[3][5].control = 1
          columns[5][5].control = 1
          columns[6][5].control = 1
          played_slot = columns[4][5]
          played_slot.control = 1
          expect(rack.winning_string?(1, played_slot, :horizontal)).to eq(true)
        end
      end
    end

    context 'when checking for friends diagonally, from top right to bottom left' do
      context 'when only two pieces to the top right are friendly' do
        it 'returns true' do
          columns = rack.instance_variable_get(:@columns)
          columns[5][4].control = 1
          columns[6][3].control = 1
          played_slot = columns[4][5]
          played_slot.control = 1
          expect(rack.winning_string?(1, played_slot, :diagonal1)).to eq(false)
        end
      end

      context 'when three pieces to the bottom left are friendly' do
        it 'returns true' do
          columns = rack.instance_variable_get(:@columns)
          columns[5][2].control = 1
          columns[4][3].control = 1
          columns[3][4].control = 1
          played_slot = columns[6][1]
          played_slot.control = 1
          expect(rack.winning_string?(1, played_slot, :diagonal1)).to eq(true)
        end
      end

      context 'when two pieces to the bottom left and one piece to the top right are friendly' do
        it 'returns true' do
          columns = rack.instance_variable_get(:@columns)
          columns[6][0].control = 1
          columns[4][2].control = 1
          columns[3][3].control = 1
          played_slot = columns[5][1]
          played_slot.control = 1
          expect(rack.winning_string?(1, played_slot, :diagonal1)).to eq(true)
        end
      end
    end
  end
end
