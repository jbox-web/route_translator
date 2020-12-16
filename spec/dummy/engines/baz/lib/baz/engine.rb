module Baz
  class Engine < ::Rails::Engine
    isolate_namespace Baz
    extend RouteTranslator::Railtie::Localized

    add_route_translator_for(:baz_engine)
  end
end
