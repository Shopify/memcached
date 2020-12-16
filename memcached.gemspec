# -*- encoding: utf-8 -*-
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "memcached"
  s.version = "2.0.0.alpha"

  s.authors = ['Burke Libbey', "Arthur Neves", "Evan Weaver"]
  s.email = "arthurnn@gmail.com"
  s.description = "An interface to the libmemcached C client."
  s.summary = "An interface to the libmemcached C client."
  s.homepage = "http://github.com/shopify/memcached/"

  s.files         = %x(git ls-files -- {lib,ext,vendor}/*).split("\n") + %w(LICENSE README.md CHANGELOG)
  s.test_files    = %x(git ls-files -- {test}/*).split("\n")
  s.require_paths = ["lib", "ext"]
  s.extensions = ["ext/memcached/extconf.rb"]

  s.licenses = ["Academic Free License 3.0 (AFL-3.0)"]

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
  s.add_development_dependency('mocha')
  s.add_development_dependency('activesupport')
  s.add_development_dependency("rake-compiler")
end
