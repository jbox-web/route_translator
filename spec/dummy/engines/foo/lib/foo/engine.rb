# frozen_string_literal: true

module Foo
  class Engine < ::Rails::Engine
    isolate_namespace Foo
    extend RouteTranslator::Railtie::Localized

    add_route_translator_for(:foo_engine, {
      default_locale:    :pt,
      available_locales: %i[pt es en],
    })

  end
end
