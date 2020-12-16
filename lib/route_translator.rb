# frozen_string_literal: true

require 'addressable/uri'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module RouteTranslator

  class BaseError          < StandardError; end
  class TranslatorNotFound < BaseError; end

  require 'route_translator/railtie' if defined?(::Rails::Railtie)

  def self.add_translator(engine, opts = {})
    @translators ||= {}
    @translators[engine] = Translator.new(engine, opts)
  end


  def self.translator_for(engine)
    @translators[engine]
  end

end

ActionDispatch::Routing::Mapper.prepend(RouteTranslator::CoreExt::MapperPatch)
ActionDispatch::Routing::RouteSet.prepend(RouteTranslator::CoreExt::RouteSetPatch)
