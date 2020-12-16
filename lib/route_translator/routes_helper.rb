# frozen_string_literal: true

module RouteTranslator
  module RoutesHelper
    module_function

    # Add standard route helpers for default locale e.g.
    #   I18n.locale = :de
    #   people_path -> people_de_path
    #   I18n.locale = :fr
    #   people_path -> people_fr_path
    def add(old_name, named_route_collection, engine)
      helper_list = named_route_collection.helper_names
      translator  = RouteTranslator.translator_for(engine)

      %w[path url].each do |suffix|
        helper_container = named_route_collection.send(:"#{suffix}_helpers_module")
        new_helper_name = "#{old_name}_#{suffix}"

        helper_list.push(new_helper_name.to_sym) unless helper_list.include?(new_helper_name.to_sym)

        helper_container.__send__(:define_method, new_helper_name) do |*args|
          __send__(translator.route_name_for(args, old_name, suffix, self), *args)
        end
      end
    end

  end
end
