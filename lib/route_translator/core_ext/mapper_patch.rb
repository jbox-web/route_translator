# frozen_string_literal: true

module RouteTranslator
  module CoreExt
    module MapperPatch
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


        def add_route(action, controller, options, _path, to, via, formatted, anchor, options_constraints)
          return super unless @localized

          localized_add_route(action, controller, options, _path, to, via, formatted, anchor, options_constraints)
        end


        def localized_add_route(action, controller, options, _path, to, via, formatted, anchor, options_constraints)
          # From Rails source
          # See: https://github.com/rails/rails/blob/master/actionpack/lib/action_dispatch/routing/mapper.rb#L1962
          path = path_for_action(action, _path)
          raise ArgumentError, "path is required" if path.blank?

          action = action.to_s

          default_action = options.delete(:action) || @scope[:action]

          if /^[\w\-\/]+$/.match?(action)
            default_action ||= action.tr("-", "_") unless action.include?("/")
          else
            action = nil
          end

          as = if !options.fetch(:as, true) # if it's set to nil or false
            options.delete(:as)
          else
            name_for_action(options.delete(:as), action)
          end

          path = ActionDispatch::Routing::Mapper::Mapping.normalize_path URI_PARSER.escape(path), formatted
          ast = ActionDispatch::Journey::Parser.parse path

          mapping = ActionDispatch::Routing::Mapper::Mapping.build(@scope, @set, ast, controller, default_action, to, via, formatted, options_constraints, anchor, options)
          # End of Rails source

          # Original
          # @set.add_route(mapping, as)

          # Our override
          _add_localized_route(@scope, @set, ast, controller, default_action, to, via, formatted, options_constraints, anchor, options, mapping, as, path, @engine)
        end


        def _add_localized_route(scope, set, ast, controller, default_action, to, via, formatted, options_constraints, anchor, options, mapping, as, path, engine)
          route = RouteTranslator::Route.new(set, path, as, options_constraints, options, mapping)
          translator = RouteTranslator.translator_for(engine)

          raise RouteTranslator::TranslatorNotFound, "RouteTranslator is not configured for current engine : #{engine}" if translator.nil?

          translator.translations_for(route) do |locale, translated_name, translated_path, translated_options_constraints, translated_options|
            translated_path_ast = ::ActionDispatch::Journey::Parser.parse(translated_path)
            translated_mapping  = _translate_mapping(locale, set, translated_options, translated_path_ast, scope, controller, default_action, to, formatted, via, translated_options_constraints, anchor)

            # call original method
            set.add_route translated_mapping, translated_name
          end
        end


        def _translate_mapping(locale, route_set, translated_options, translated_path_ast, scope, controller, default_action, to, formatted, via, translated_options_constraints, anchor)
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
