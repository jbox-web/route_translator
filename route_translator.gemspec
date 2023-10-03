# frozen_string_literal: true

require_relative 'lib/route_translator/version'

Gem::Specification.new do |s|
  s.name          = 'route_translator'
  s.version       = RouteTranslator::VERSION::STRING
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Nicolas Rodriguez']
  s.email         = ['nicoladmin@free.fr']
  s.homepage      = 'http://github.com/jbox-web/route_translator'
  s.summary       = 'Translate your Rails routes in a simple manner'
  s.description   = 'Translates the Rails routes of your application into the languages defined in your locale files'
  s.license       = 'MIT'

  s.required_ruby_version = '>= 3.0.0'

  s.files = `git ls-files`.split("\n")

  s.add_runtime_dependency 'addressable'
  s.add_runtime_dependency 'rails', '>= 6.0'
  s.add_runtime_dependency 'zeitwerk'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3', '~> 1.4.0'

  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1.0")
    s.add_development_dependency 'net-imap'
    s.add_development_dependency 'net-pop'
    s.add_development_dependency 'net-smtp'
  end
end
