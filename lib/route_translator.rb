# frozen_string_literal: true

# require external dependencies
require 'addressable/uri'
require 'zeitwerk'

# load zeitwerk
Zeitwerk::Loader.for_gem.tap do |loader| # rubocop:disable Style/SymbolProc
  loader.setup
end

module RouteTranslator

  class BaseError          < StandardError; end
  class TranslatorNotFound < BaseError; end

  require_relative 'route_translator/railtie' if defined?(::Rails::Railtie)

  @translators = {}

  def self.add_translator(engine, opts = {})
    @translators[engine] = Translator.new(engine, opts)
  end


  def self.translator_for(engine)
    @translators[engine]
  end


  def self.rails_81?
    Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new('8.1.0.rc1')
  end

end
