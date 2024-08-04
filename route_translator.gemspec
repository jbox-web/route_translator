# frozen_string_literal: true

require_relative 'lib/route_translator/version'

Gem::Specification.new do |s|
  s.name          = 'route_translator'
  s.version       = RouteTranslator::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Nicolas Rodriguez']
  s.email         = ['nico@nicoladmin.fr']
  s.homepage      = 'http://github.com/jbox-web/route_translator'
  s.summary       = 'Translate your Rails routes in a simple manner'
  s.description   = 'Translates the Rails routes of your application into the languages defined in your locale files'
  s.license       = 'MIT'

  s.required_ruby_version = '>= 3.0.0'

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'addressable'
  s.add_dependency 'rails', '>= 6.1'
  s.add_dependency 'zeitwerk'
end
