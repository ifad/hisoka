module Hisoka
  module Hashable
    def eql?(other)
      self.== other
    end

    def hash
      [@name, @parent_method, @args].hash
    end

    def ==(other)
      hash == other.hash
    end
  end


  class InternalSpy
    include Hisoka::Hashable
    attr_reader :parent_method, :name, :args

    def initialize(env, name, logger, parent_method, args)
      @env = env
      @name = name
      @logger = logger || default_logger
      @parent_method = parent_method
      @args = args
    end

    def default_logger
      Rails.logger || StdoutLogger.new
    rescue
      StdoutLogger.new
    end

    def new_child_node(method_name, args)
      parent_method = [@parent_method, method_name].compact.join(".")

      @env.class.new(@name, @logger, parent_method, args)
    end

    def called_method(method_name, *args)
      args = format_args(args)
      non_hisoka_stack = caller[0..last_hisoka_stack_index(caller)]

      msg = format_log_message(non_hisoka_stack)

      @logger.info "#{msg} #{method_chain_from(method_name)} #{args}"

      new_child_node(method_name, args)
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
      call_info = format_stack_trace(non_hisoka_stack)
      title = Hisoka.C("Hisoka", :bold, :blue)

      title = "#{title}: #{@name} ".ljust(50, " ")
      stack = "(#{call_info} )"

      "#{title} #{stack}"
    end

    #TODO make stack trace tidying configurable
    def format_stack_trace(stack)
      call_info = stack[2..2][0].to_s.gsub(/:in `.*haml[\d|_]*'$/, "")
      call_info.gsub!(/#{Rails.root}/, "") rescue nil
      call_info.gsub! %r{/.*/lib/ruby/gems/1.9.1/gems}, "gems"
      call_info
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
