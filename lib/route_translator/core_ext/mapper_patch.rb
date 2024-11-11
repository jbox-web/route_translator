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
          @set.add_localized_route(@scope, ast, controller, default_action, to, via, formatted, options_constraints, anchor, options, mapping, as, path, @engine)
        end

    end
  end
end
