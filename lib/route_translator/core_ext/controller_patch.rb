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

          params[route_translator.locale_param_key] || route_translator.default_locale
        end


        def route_translator
          @route_translator ||= RouteTranslator.translator_for(localized_engine)
        end

    end
  end
end
