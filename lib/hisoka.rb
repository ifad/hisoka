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

module Hisoka
end
