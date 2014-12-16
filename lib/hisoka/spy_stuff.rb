module Hisoka
  module SpyStuff
    def self.included(base)
      base.class_eval do
        delegate :==, :eql?, :hash, :to => :internal_spy
      end
    end

    # we include the absolute minimum in objects to reduce
    # their surface area and compose of an InternalSpy instance
    def initialize(name, logger=nil, parent_method=nil, args=nil)
      @_internal_spy = InternalSpy.new(self, name, logger, parent_method, args)
    end

    def method_missing(method_name, *args)
      @_internal_spy.called_method(method_name, *args)
    end

    def internal_spy
      @_internal_spy
    end
  end
end

