# frozen_string_literal: true

require_relative '../lib/string'

# A class to manage the properties of one slot on the rack
class Slot
  attr_accessor :column, :row, :control, :adjacents

  def initialize(column, row)
    @column = column
    @row = row
    @control = 0
    @adjacents = set_adjacents
  end

  def draw
    @column == 7 ? "|#{piece} |\n" : "|#{piece} "
  end

  private

  def piece
    pieces = { 0 => ' ', 1 => "\u278A".colorize(31), 2 => "\u278B".colorize(33) }
    pieces[@control]
  end

  def set_adjacents
    [adjacent_top, adjacent_top_right, adjacent_right, adjacent_bottom_right,
     adjacent_bottom, adjacent_bottom_left, adjacent_left, adjacent_top_left]
  end

  def adjacent_top
    @row == 1 ? nil : [@column, @row - 1]
  end

  def adjacent_top_right
    @row == 1 || @column == 7 ? nil : [@column + 1, @row - 1]
  end

  def adjacent_right
    @column == 7 ? nil : [@column + 1, @row]
  end

  def adjacent_bottom_right
    @row == 6 || @column == 7 ? nil : [@column + 1, @row + 1]
  end

  def adjacent_bottom
    @row == 6 ? nil : [@column, @row + 1]
  end

  def adjacent_bottom_left
    @row == 6 || @column == 1 ? nil : [@column - 1, @row + 1]
  end

  def adjacent_left
    @column == 1 ? nil : [@column - 1, @row]
  end

  def adjacent_top_left
    @row == 1 || @column == 1 ? nil : [@column - 1, @row - 1]
  end
end
