# frozen_string_literal: true

module RouteTranslator
  module CoreExt
    module RouteSetPatch
      extend ActiveSupport::Concern

      def add_localized_route(scope, ast, controller, default_action, to, via, formatted, options_constraints, anchor, options, mapping, name, path, engine)
        route = RouteTranslator::Route.new(self, path, name, options_constraints, options, mapping)
        translator = RouteTranslator.translator_for(engine)

        raise RouteTranslator::TranslatorNotFound, "RouteTranslator is not configured for current engine : #{engine}" if translator.nil?

        translator.translations_for(route) do |locale, translated_name, translated_path, translated_options_constraints, translated_options|
          translated_path_ast = ::ActionDispatch::Journey::Parser.parse(translated_path)
          translated_mapping  = translate_mapping(locale, self, translated_options, translated_path_ast, scope, controller, default_action, to, formatted, via, translated_options_constraints, anchor)

          # call original method
          add_route translated_mapping, translated_name
        end
      end


      private


        def translate_mapping(locale, route_set, translated_options, translated_path_ast, scope, controller, default_action, to, formatted, via, translated_options_constraints, anchor)
          scope_params = {
            blocks:      scope[:blocks] || [],
            constraints: scope[:constraints] || {},
            defaults:    (scope[:defaults] || {}).dup,
            module:      scope[:module],
            options:     scope[:options] ? scope[:options].merge(translated_options) : translated_options
          }

          ::ActionDispatch::Routing::Mapper::Mapping.build scope_params, route_set, translated_path_ast, controller, default_action, to, via, formatted, translated_options_constraints, anchor, translated_options
        end

    end
  end
end
