# frozen_string_literal: true

# Load ruby-warning gem
require 'warning'

Warning[:deprecated]   = true
Warning[:experimental] = true
Warning[:performance]  = true if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3.0')

# Ignore all warnings in Gem dependencies
Gem.path.each do |path|
  Warning.ignore(//, path)
end

# Ignore method redefinitions
Warning.ignore(/warning: previous definition of/)
Warning.ignore(/warning: method redefined;/)

# Load simplecov
require 'simplecov'
require 'simplecov_json_formatter'

# Start SimpleCov
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter, SimpleCov::Formatter::JSONFormatter])
  add_filter 'spec/'
end

# Load Rails dummy app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)

# Load test gems
require 'rspec/rails'

# Load dbg gem
require 'dbg-rb'

# Configure RSpec
RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # disable monkey patching
  # see: https://relishapp.com/rspec/rspec-core/v/3-8/docs/configuration/zero-monkey-patching-mode
  config.disable_monkey_patching!
end

# Configure dbg
DbgRb.highlight!('🎉💔💣🕺🚀🧨🙈🤯🥳🌈🦄')

module TestEngine
  class Engine < ::Rails::Engine
    isolate_namespace TestEngine
  end

  class ApplicationController < ::ActionController::Base
  end

  class WelcomeController < ApplicationController
    def index; end
  end
end
