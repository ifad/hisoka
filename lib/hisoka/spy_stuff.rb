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
  module SpyStuff
    extend ActiveSupport::Concern

    def initialize(name, logger=nil)
      @name = name
      @logger ||= (Rails.logger rescue StdoutLogger.new)
    end

    def parent_method=(m)
      @parent_method = m
    end

    def new_child_node(name, parent_method=nil)
      self.class.new(name).tap{|r|r.parent_method = parent_method}
    end

    def method_missing(method_name, *args)
      called_method(method_name, *args)
    end

    def called_method(method_name, *args)
      args = if args.empty?
               ""
             else
               "with args #{args.to_s}"
             end

      call_info = caller[1..1][0].to_s.gsub(/:in `.*haml[\d|_]*'$/, "")
      call_info.gsub!(/#{Rails.root}/, "") rescue nil

      title = Hisoka.C("\nHisoka", :bold, :blue)

      title = "#{title}: #{@name} ".ljust(50, " ")
      meth = "#{@parent_method}.#{Hisoka.C(method_name.to_s,:cyan)} "
      stack = "(called from #{call_info} )"

      @logger.info "#{title} #{stack} #{meth} #{args}"

      new_child_node(@name, [@parent_method, method_name].compact.join("."))
    end

    def to_s
      "#{self.class.name} `#{@name}'"
    end
  end
end

