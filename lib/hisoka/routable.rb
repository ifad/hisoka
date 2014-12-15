module Hisoka
  class Routable < Iterable
    def id
      "some-id"
    end

    def to_param
      id
    end
  end
end
