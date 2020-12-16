# frozen_string_literal: true

require_relative 'lib/foo/version'

Gem::Specification.new do |s|
  s.name        = 'foo'
  s.version     = Foo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/n-rodriguez/foo'
  s.summary     = 'Foo'

  s.required_ruby_version = '>= 2.5.0'

  # s.files = `git ls-files`.split("\n")
end
