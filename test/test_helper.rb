$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require 'socket'
require 'benchmark'

require 'rubygems'
require 'ruby-debug' if ENV['DEBUG']
require 'memcached'

require 'minitest/autorun'
require 'mocha/minitest'
require 'ostruct'
require 'socket'

require_relative 'setup'

UNIX_SOCKET_NAME = File.join(ENV['TMPDIR']||'/tmp','memcached') unless defined? UNIX_SOCKET_NAME

class GenericClass
end

module Minitest::Assertions
  private

  def assert_nothing_raised(*)
    yield
  end

  alias_method :assert_raise, :assert_raises
  alias_method :assert_not_equal, :refute_equal
  alias_method :assert_not_nil, :refute_nil
end
