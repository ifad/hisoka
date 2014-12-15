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
    # we include the absolute minimum in objects to reduce
    # their surface area and compose of a HisakoInternalSpy instance
    def initialize(name, logger=nil, parent_method=nil)
      @_internal_spy = HisokaInternalSpy.new(self, name, logger)
      @_internal_spy.parent_method = parent_method
    end

    def method_missing(method_name, *args)
      @_internal_spy.called_method(method_name, *args)
    end

    class HisokaInternalSpy
      attr_reader :parent_method, :name

      def initialize(env, name, logger=nil)
        @env = env
        @name = name
        @logger = (logger || Rails.logger rescue StdoutLogger.new)
      end

      def parent_method=(m)
        @parent_method = m
      end

      def new_child_node(name, parent_method=nil)
        child = @env.class.new(name, @logger, parent_method)
      end

      def called_method(method_name, *args)
        args = format_args(args)
        non_hisoka_stack = caller[0..last_hisoka_stack_index(caller)]

        msg = format_log_message(non_hisoka_stack)

        @logger.info "#{msg} #{method_chain_from(method_name)} #{args}"

        new_child_node(@name, [@parent_method, method_name].compact.join("."))
      end

      def method_chain_from(m)
        "#{@parent_method}.#{Hisoka.C(m.to_s,:cyan)} "
      end

      def format_args(a)
        if a.empty?
          ""
        else
          "with args #{a.to_s}"
        end
      end

      def format_log_message(non_hisoka_stack)
        #TODO make stack trace tidying configurable
        call_info = non_hisoka_stack[2..2][0].to_s.gsub(/:in `.*haml[\d|_]*'$/, "")
        call_info.gsub!(/#{Rails.root}/, "") rescue nil

        title = Hisoka.C("\nHisoka", :bold, :blue)

        title = "#{title}: #{@name} ".ljust(50, " ")
        stack = "(called from #{call_info} )"

        "#{title} #{stack}"
      end

      def last_hisoka_stack_index(stack)
        stack.map.
          with_index{|c, i| stack.grep(/hisoka/).  last == c ? i : nil}.
          compact.
          last
      end

      def to_s
        "#{self.class.name} `#{@name}'"
      end
    end
  end
end

