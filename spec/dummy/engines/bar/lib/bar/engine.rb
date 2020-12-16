# frozen_string_literal: true

module Bar
  class Engine < ::Rails::Engine
    isolate_namespace Bar
    extend RouteTranslator::Railtie::Localized

    add_route_translator_for(:bar_engine, {
      default_locale:    :es,
      available_locales: %i[es pt en],
    })

  end
end
