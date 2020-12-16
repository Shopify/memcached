# memcached

An interface to the libmemcached C client.
[![Build Status](https://travis-ci.org/shopify/memcached.svg?branch=master)](https://travis-ci.org/shopify/memcached)

## License

Copyright Shopify Inc, under AFL 3. Portions copyright 2009-2013 Cloudburst, LLC, AFL 3. Portions
copyright 2007-2009 TangentOrg, Brian Aker, licensed under the BSD license, and used with
permission.

## Features

* clean API
* robust access to all memcached features
* SASL support for the binary protocol
* multiple hashing modes, including consistent hashing
* ludicrous speed, including optional pipelined IO with no_reply

The **memcached** library wraps the pure-C libmemcached client via SWIG.

## Installation

Tested with ruby 2.7, but should work with much older versions.

You also need the `libsasl2-dev` and `gettext` libraries, which should be provided through your
system's package manager.

Install the gem:

```bash
gem install memcached
```

## Usage

Start a local networked memcached server:

```bash
# (e.g.)
memcached -p 11211 &
```

Now, in Ruby, require the library and instantiate a Memcached object at a global level:

```ruby
require('memcached')
$cache = Memcached.new("localhost:11211")
```

Now you can set things and get things:

```ruby
value = 'hello'
$cache.set('test', value)
$cache.get('test') #=> "hello"
```

You can set with an expiration timeout:

```ruby
value = 'hello'
$cache.set('test', value, 1)
sleep(2)
$cache.get('test') #=> raises Memcached::NotFound
```

You can get multiple values at once:

```ruby
value = 'hello'
$cache.set('test', value)
$cache.set('test2', value)
$cache.get(['test', 'test2', 'missing'])
  #=> {"test" => "hello", "test2" => "hello"}
```

You can set a counter and increment it. Note that you must initialize it with an integer, encoded as
an unmarshalled ASCII string:

```ruby
start = 1
$cache.set('counter', start.to_s, 0, false)
$cache.increment('counter') #=> 2
$cache.increment('counter') #=> 3
$cache.get('counter', false).to_i #=> 3
```

You can get some server stats:

```ruby
$cache.stats #=> {..., :bytes_written=>[62], :version=>["1.2.4"] ...}
```

Note that the API is not the same as that of **Ruby-MemCache** or **memcache-client**. In
particular, `nil` is a valid record value. Memcached#get does not return `nil` on failure, rather it
raises **Memcached::NotFound**. This is consistent with the behavior of memcached itself. For
example:

```ruby
$cache.set('test', nil)
$cache.get('test') #=> nil
$cache.delete('test')
$cache.get('test') #=> raises Memcached::NotFound
```

## Rails

Use [memcached_store gem](https://github.com/Shopify/memcached_store) to integrate ActiveSupport
cache store and memcached gem

## Pipelining

Pipelining updates is extremely effective in **memcached**, leading to more than 25x write
throughput than the default settings. Use the following options to enable it:

```ruby
{
  no_block: true,
  buffer_requests: true,
  noreply: true,
  binary_protocol: false
}
```

Currently #append, #prepend, #set, and #delete are pipelined. Note that when you perform a read, all
pending writes are flushed to the servers.

## Threading

**memcached** is threadsafe, but each thread requires its own Memcached instance. Create a global
Memcached, and then call Memcached#clone each time you spawn a thread.

```ruby
thread = Thread.new do
  cache = $cache.clone
  # Perform operations on cache, not $cache
  cache.set('example', 1)
  cache.get('example')
end

# Join the thread so that exceptions don't get lost
thread.join
```

## Benchmarks

**memcached**, correctly configured, is at least twice as fast as
**memcache-client** and **dalli**. See link:BENCHMARKS for details.

## Reporting problems

The support forum is [here](http://github.com/arthurnn/memcached/issues).

Patches and contributions are very welcome. Please note that contributors are required to assign
copyright for their additions to Cloudburst, LLC.

## Further resources

* [Memcached wiki](https://github.com/memcached/memcached/wiki)
* [Libmemcached homepage](http://libmemcached.org)

