# frozen_string_literal: true

module RouteTranslator
  module CoreExt
    module MapperPatch81
      extend ActiveSupport::Concern

      URI_PARSER = defined?(URI::RFC2396_PARSER) ? URI::RFC2396_PARSER : URI::DEFAULT_PARSER
      private_constant :URI_PARSER


      def localized(engine)
        @localized = true
        @engine = engine
        yield
        @localized = false
        @engine = nil
      end


      private


        def add_route(action, controller, as, options_action, _path, to, via, formatted, anchor, options_constraints, internal, options_mapping)
          return super unless @localized

          localized_add_route(action, controller, as, options_action, _path, to, via, formatted, anchor, options_constraints, internal, options_mapping)
        end


        def localized_add_route(action, controller, as, options_action, _path, to, via, formatted, anchor, options_constraints, internal, options_mapping)
          # From Rails source
          # See: https://github.com/rails/rails/blob/v8.1.0.rc1/actionpack/lib/action_dispatch/routing/mapper.rb#L2193
          path = path_for_action(action, _path)
          raise ArgumentError, "path is required" if path.blank?

          action = action.to_s

          default_action = options_action || @scope[:action]

          if /^[\w\-\/]+$/.match?(action)
            default_action ||= action.tr("-", "_") unless action.include?("/")
          else
            action = nil
          end

          as   = name_for_action(as, action) if as
          path = ActionDispatch::Routing::Mapper::Mapping.normalize_path URI_PARSER.escape(path), formatted
          ast  = ActionDispatch::Journey::Parser.parse path

          mapping = ActionDispatch::Routing::Mapper::Mapping.build(@scope, @set, ast, controller, default_action, to, via, formatted, options_constraints, anchor, internal, options_mapping)
          # End of Rails source

          # Original
          # @set.add_route(mapping, as)

          # Our override
          _add_localized_route(@scope, @set, ast, controller, default_action, to, via, formatted, options_constraints, anchor, internal, options_mapping, mapping, as, path, @engine)
        end


        def _add_localized_route(scope, set, ast, controller, default_action, to, via, formatted, options_constraints, anchor, internal, options_mapping, mapping, as, path, engine)
          translator = RouteTranslator.translator_for(engine)
          raise RouteTranslator::TranslatorNotFound, "RouteTranslator is not configured for current engine : #{engine}" if translator.nil?

          route = RouteTranslator::Route.new(set, path, as, options_constraints, options_mapping, mapping)

          translator.translations_for(route) do |locale, translated_name, translated_path, translated_options_constraints, translated_options|
            translated_path_ast = ::ActionDispatch::Journey::Parser.parse(translated_path)
            translated_mapping  = _translate_mapping(locale, set, translated_options, translated_path_ast, scope, controller, default_action, to, formatted, via, translated_options_constraints, anchor, internal)

            # call original method
            set.add_route translated_mapping, translated_name
          end
        end


        def _translate_mapping(locale, route_set, translated_options, translated_path_ast, scope, controller, default_action, to, formatted, via, translated_options_constraints, anchor, internal)
          scope_params = {
            blocks:      scope[:blocks] || [],
            constraints: scope[:constraints] || {},
            defaults:    (scope[:defaults] || {}).dup,
            module:      scope[:module],
            options:     scope[:options] ? scope[:options].merge(translated_options) : translated_options
          }

          ::ActionDispatch::Routing::Mapper::Mapping.build scope_params, route_set, translated_path_ast, controller, default_action, to, via, formatted, translated_options_constraints, anchor, internal, translated_options
        end

    end
  end
end
