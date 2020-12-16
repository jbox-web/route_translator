# frozen_string_literal: true

require_relative 'lib/bar/version'

Gem::Specification.new do |s|
  s.name        = 'bar'
  s.version     = Bar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nicoladmin@free.fr']
  s.homepage    = 'https://github.com/n-rodriguez/bar'
  s.summary     = 'Bar'

  s.required_ruby_version = '>= 2.5.0'

  # s.files = `git ls-files`.split("\n")
end
