# frozen_string_literal: true

module RouteTranslator
  class Route
    attr_reader :route_set, :path, :name, :options_constraints, :options, :mapping, :scope

    def initialize(route_set, path, name, options_constraints, options, mapping) # rubocop:disable Metrics/ParameterLists, Metrics/MethodLength
      @route_set           = route_set
      @path                = path
      @name                = name
      @options_constraints = options_constraints
      @options             = options
      @mapping             = mapping

      @scope =
        if mapping.defaults[:controller]
          %i[routes controllers].concat mapping.defaults[:controller].split('/').map(&:to_sym)
        else
          %i[routes controllers]
        end
    end

  end
end
