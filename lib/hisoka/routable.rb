module Hisoka
  #Routable objects can be used in Rails forms
  #and link_to helpers
  class Routable < Iterable
    def id
      "some-id"
    end

    def to_param
      id
    end
  end
end
