# frozen_string_literal: true

require_relative 'lib/baz/version'

Gem::Specification.new do |s|
  s.name        = 'baz'
  s.version     = Baz::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nicolas Rodriguez']
  s.email       = ['nico@nicoladmin.fr']
  s.homepage    = 'https://github.com/n-rodriguez/baz'
  s.summary     = 'Baz'

  s.required_ruby_version = '>= 2.5.0'

  # s.files = `git ls-files`.split("\n")
end
