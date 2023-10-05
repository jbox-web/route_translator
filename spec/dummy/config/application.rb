# frozen_string_literal: true

# Load Bundler
require_relative 'boot'

# Load Rails
require 'rails/all'

# Load tested lib
# It must happen before Bundler.require otherwise Rails engines
# won't be able to load RouteTranslator::Railtie::Localized
require 'route_translator'

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    extend RouteTranslator::Railtie::Localized

    config.load_defaults Rails::VERSION::STRING.to_f

    config.i18n.available_locales = %i[fr en es pt]
    config.i18n.default_locale    = :fr
    config.i18n.fallbacks         = [:fr, { en: %i[en fr], es: %i[es fr], pt: %i[pt es fr] }]

    add_route_translator_for(:main_site, {
      default_locale:    :fr,
      available_locales: %i[fr es pt en],
    })

  end
end
