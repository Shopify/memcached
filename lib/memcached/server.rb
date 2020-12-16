# frozen_string_literal: true
module Memcached
  class Server
    attr_reader(:hostname)
    attr_reader(:port)
    attr_reader(:weight)

    def initialize(name, port, weight = nil)
      @hostname = name
      @port = port
      @weight = weight
    end

    def to_s
      s = hostname.dup
      s << ":#{port}" if 0 != port
      s << "/?#{weight}" if weight
      s
    end
  end
end
