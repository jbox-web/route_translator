# frozen_string_literal: true

require 'simplecov'
require 'simplecov_json_formatter'

# Start SimpleCov
SimpleCov.start do
  formatter SimpleCov::Formatter::JSONFormatter
  add_filter 'spec/'
end

# Load Rails dummy app
ENV['RAILS_ENV'] = 'test'
require File.expand_path('dummy/config/environment.rb', __dir__)

# Load test gems
require 'rspec/rails'

# Load our own config
require_relative 'config_rspec'

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
