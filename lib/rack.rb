# frozen_string_literal: true

require_relative '../lib/slot'

# The class that represents the collection of slots that make up the game rack
class Rack
  attr_accessor :columns, :winner

  def initialize
    @columns = []
    @winner = 0
    7.times { |column| @columns.push(setup_column(column)) }
    @adjacents_ref = { vertical: [0, 4], horizontal: [2, 6], diagonal1: [1, 5], diagonal2: [3, 7] }
  end

  def draw
    puts "\n"
    6.times { |row| draw_row(row) }
    print '  '
    22.times { print '=' }
    print "\n  "
    7.times { |column| print " #{column + 1} " }
    puts "\n"
  end

  def place_piece(player_number, column)
    return :out_of_range unless column.is_a?(Integer) && column.between?(1, 7)

    row = find_max_row(@columns[column - 1])

    return :no_place if row.zero?

    played_slot = @columns[column - 1][row - 1]

    played_slot.control = player_number

    @winner = player_number if connect4?(player_number, played_slot)

    :play_complete
  end

  private

  def connect4?(player_number, slot)
    winning_array = []
    @adjacents_ref.each_key { |key| winning_array.push(winning_string?(player_number, slot, key)) }
    winning_array.any?(true)
  end

  def winning_string?(player_number, slot, direction)
    control_array = find_adjacents(slot, [slot.control], @adjacents_ref[direction][0], true)
    control_array_str = find_adjacents(slot, control_array, @adjacents_ref[direction][1], false).to_s

    winning_string = player_number == 1 ? '1, 1, 1, 1' : '2, 2, 2, 2'
    control_array_str.include?(winning_string)
  end

  def find_max_row(focus_column)
    column_state = []
    focus_column.each { |slot| column_state.push(slot.row) if slot.control.zero? }
    column_state.last.nil? ? 0 : column_state.last
  end

  def draw_row(row)
    print '  '
    @columns.each { |column| column.each { |slot| print slot.draw if slot.row == row + 1 } }
  end

  def setup_column(column)
    column_array = []
    6.times { |row| column_array.push(Slot.new(column + 1, row + 1)) }
    column_array
  end

  def find_adjacents(slot, control_array, adjacents_ref, append)
    slot_adjacent_ref = slot.adjacents[adjacents_ref]

    return control_array if slot_adjacent_ref.nil?

    slot_adjacent = @columns[slot_adjacent_ref[0] - 1][ slot_adjacent_ref[1] - 1]
    append ? control_array.push(slot_adjacent.control) : control_array.unshift(slot_adjacent.control)

    find_adjacents(slot_adjacent, control_array, adjacents_ref, append)
  end
end
