# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/slot'

describe Slot do
  red_piece = "\e[31m\u278A\e[0m"
  yellow_piece = "\e[33m\u278B\e[0m"

  describe '#initialize' do
    context 'when the slot is first created' do
      column = 1
      row = 1
      subject(:new_slot) { described_class.new(column, row) }

      it 'has a column number' do
        column_var = new_slot.instance_variable_get(:@column)
        expect(column_var).to eq(column)
      end

      it 'has a row number' do
        row_var = new_slot.instance_variable_get(:@row)
        expect(row_var).to eq(row)
      end

      it 'has a default control number set to zero' do
        control_var = new_slot.instance_variable_get(:@control)
        expect(control_var).to be_zero
      end

      it 'has identified its adjacents' do
        adjacents_var = new_slot.instance_variable_get(:@adjacents)
        expect(adjacents_var).to eq([nil, nil, [2, 1], [2, 2], [1, 2], nil, nil, nil])
      end
    end

    context 'when the slot is in the middle of the rack' do
      column = 4
      row = 4
      subject(:middle_slot) { described_class.new(column, row) }

      it 'has identified its adjacents' do
        adjacents_var = middle_slot.instance_variable_get(:@adjacents)
        expect(adjacents_var).to eq([[4, 3], [5, 3], [5, 4], [5, 5], [4, 5], [3, 5], [3, 4], [3, 3]])
      end
    end
  end

  describe '#piece' do
    column = 1
    row = 1
    context 'when the slot is not controlled by any player' do
      subject(:empty_slot) { described_class.new(column, row) }

      it 'returns a blank space' do
        expect(empty_slot.piece).to eq(' ')
      end
    end

    context 'when the slot is controlled by player1' do
      subject(:p1_slot) { described_class.new(column, row) }

      before do
        p1_slot.instance_variable_set(:@control, 1)
      end

      it 'returns a red piece' do
        expect(p1_slot.piece).to eq(red_piece)
      end
    end

    context 'when the slot is controlled by player2' do
      subject(:p2_slot) { described_class.new(column, row) }

      before do
        p2_slot.instance_variable_set(:@control, 2)
      end

      it 'returns a yellow piece' do
        expect(p2_slot.piece).to eq(yellow_piece)
      end
    end
  end

  describe '#draw' do
    row = 1
    context 'when the slot is not controlled by any player' do
      context 'when the column number is not equal to 7' do
        column = 3
        subject(:empty_slot) { described_class.new(column, row) }

        it "returns '|  '" do
          expect(empty_slot.draw).to eq('|  ')
        end
      end

      context 'when the column number is equal to 7' do
        column = 7
        subject(:empty_slot) { described_class.new(column, row) }

        it "returns '|  |'" do
          expect(empty_slot.draw).to eq("|  |\n")
        end
      end
    end

    context 'when the slot is controlled by player1' do
      context 'when the column number is not equal to 7' do
        column = 3
        subject(:p1_slot) { described_class.new(column, row) }

        before do
          p1_slot.instance_variable_set(:@control, 1)
        end

        it "returns '|#{red_piece} '" do
          expect(p1_slot.draw).to eq("|#{red_piece} ")
        end
      end

      context 'when the column number is equal to 7' do
        column = 7
        subject(:p1_slot) { described_class.new(column, row) }

        before do
          p1_slot.instance_variable_set(:@control, 1)
        end

        it "returns '|#{red_piece} |'" do
          expect(p1_slot.draw).to eq("|#{red_piece} |\n")
        end
      end
    end

    context 'when the slot is controlled by player2' do
      context 'when the column number is not equal to 7' do
        column = 3
        subject(:p2_slot) { described_class.new(column, row) }

        before do
          p2_slot.instance_variable_set(:@control, 2)
        end

        it "returns '|#{yellow_piece} '" do
          expect(p2_slot.draw).to eq("|#{yellow_piece} ")
        end
      end

      context 'when the column number is equal to 7' do
        column = 7
        subject(:p2_slot) { described_class.new(column, row) }

        before do
          p2_slot.instance_variable_set(:@control, 2)
        end

        it "returns '|#{yellow_piece} |'" do
          expect(p2_slot.draw).to eq("|#{yellow_piece} |\n")
        end
      end
    end
  end
end
