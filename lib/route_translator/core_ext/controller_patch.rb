# frozen_string_literal: true

module RouteTranslator
  module CoreExt
    module ControllerPatch
      extend ActiveSupport::Concern

      included do
        class_attribute :localized_engine

        class << self
          def localized(engine)
            self.localized_engine = engine
          end
        end
      end


      private


        def set_locale_from_params
          locale_from_params = extract_locale_from_params

          if locale_from_params
            old_locale  = I18n.locale
            I18n.locale = locale_from_params
          end

          yield
        ensure
          I18n.locale = old_locale if locale_from_params
        end


        def extract_locale_from_params
          return if route_translator.nil?

          locale = params[route_translator.locale_param_key]

          # Guard against user-supplied locales: an unknown value would raise
          # I18n::InvalidLocale (with enforce_available_locales on) or silently
          # apply an attacker-controlled locale (with it off). Fall back to the
          # engine default when the param is missing or not an available locale.
          # Compare via #to_s so a malformed param (Array/Hash) can't raise here.
          available = route_translator.available_locales.map(&:to_s)
          return route_translator.default_locale if locale.blank? || available.exclude?(locale.to_s)

          locale
        end


        def route_translator
          @route_translator ||= RouteTranslator.translator_for(localized_engine)
        end

    end
  end
end
