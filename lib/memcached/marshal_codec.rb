# frozen_string_literal: true
module Memcached
  module MarshalCodec
    FLAG = Memcached::Client::FLAG_ENCODED

    def self.encode(_key, value, flags)
      [Marshal.dump(value), flags | FLAG]
    end

    def self.decode(_key, value, flags)
      if (flags & FLAG) != 0
        Marshal.load(value)
      else
        value
      end
    end
  end
end
