# frozen_string_literal: true

# An addon to the String class to change the colour of the text
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def initial
    self[0, 1]
  end
end
