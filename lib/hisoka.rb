begin
  require "active_support/all"
rescue LoadError
  #for older versions of AS
  begin
    require "active_support"
  rescue LoadError
  end

end


require "hisoka/version"
require "hisoka/spy_stuff"
require "hisoka/basic"
require "hisoka/tryable"
require "hisoka/iterable"
require "hisoka/routable"
require "hisoka/internal_spy"

module Hisoka
  class ColorString < String
    def blue;           Hisoka.C("\033[34m#{self}\033[0m") end
    def magenta;        Hisoka.C("\033[35m#{self}\033[0m") end
    def cyan;           Hisoka.C("\033[36m#{self}\033[0m") end
    def gray;           Hisoka.C("\033[37m#{self}\033[0m") end
    def bold;           Hisoka.C("\033[1m#{self}\033[22m") end
    def reverse_color;  Hisoka.C("\033[7m#{self}\033[27m") end
  end

  def self.C(string, *methods)
    color = ColorString.new(string)

    methods.each do |m|
      color = color.send(m)
    end

    color
  end

  class StdoutLogger
    def info(*args)
      $stdout.puts *args
    end
    def warn(*args)
      $stdout.puts *args
    end
    def error(*args)
      $stdout.puts *args
    end
  end
end
