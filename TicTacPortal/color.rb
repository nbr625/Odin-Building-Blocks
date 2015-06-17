
# This file acts as stylesheet to print
#  altered font color on the console.

def colorize(string, color_code)
  "\e[#{color_code}m#{string}\e[0m"
end
# Changes string to Blue
def blue(string)
  colorize(string, 36)
end
# Changes string to pink
def pink(string)
  colorize(string, 35)
end
