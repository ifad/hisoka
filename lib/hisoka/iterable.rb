module Hisoka
  class Iterable < Tryable
    Enumerable.instance_methods.each do |m|
      define_method(m) do |*args|
        @_internal_spy.called_method(m, *args)
      end
    end

    def as_json(*args)
      {:spy_json => to_s}.to_json
    end

    def to_json(*args)
      as_json
    end

    def to_ary(*args, &block)
      if block_given?
        each(&block).to_a
      else
        each{}.to_a
      end
    end

    def each(&block)
      called_method(:each)

      result = @_internal_spy.called_method("block-inside-each")
      block.call(result)
    end

    def to_s
      "#{self.class.name} `#{@_internal_spy.name}': #{@_internal_spy.parent_method}"
    end
  end
end
