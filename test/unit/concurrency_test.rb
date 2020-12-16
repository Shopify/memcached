# frozen_string_literal: true
require 'test_helper'

class ConcurrencyTest < BaseTest
  def test_multiple_threads_set_get
    Array.new(12) do |n|
      Thread.new do
        cache.set("foo#{n}", "v#{n}")
        assert_equal("v#{n}", cache.get("foo#{n}"))
        cache.set("foz#{n}", "v2#{n}")
        assert_equal("v2#{n}", cache.get("foz#{n}"))
      end
    end.each(&:join)
  end

  def test_threads_with_noblock
    cache = Memcached::Client.new(@servers, no_block: true)

    Array.new(12) do |n|
      Thread.new do
        100.times do |i|
          cache.set("foo#{n}#{i}", "v#{n}")
        end
        assert_equal("v#{n}", cache.get("foo#{n}2"))
      end
    end.each(&:join)
  end

  def test_threads_with_binary
    Array.new(12) do |n|
      Thread.new do
        100.times do |i|
          binary_protocol_cache.set("foo#{n}#{i}", "v#{n}")
        end
        assert_equal("v#{n}", binary_protocol_cache.get("foo#{n}2"))
      end
    end.each(&:join)
  end

  def test_threads_with_multi_get
    Array.new(12) do |n|
      Thread.new do
        keys = Array.new(100) do |i|
          binary_protocol_cache.set("foo#{n}#{i}", "v#{n}")
          "foo#{n}#{i}"
        end
        assert_equal(Array.new(100) { "v#{n}" }, binary_protocol_cache.get_multi(keys).values)
      end
    end.each(&:join)
  end
end
