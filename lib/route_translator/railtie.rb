# frozen_string_literal: true

module RouteTranslator
  class Railtie < ::Rails::Railtie

    module Localized

      def add_route_translator_for(engine, opts = {})
        RouteTranslator.add_translator(engine, opts)
      end

    end


    initializer 'route_translator.controller' do
      ActiveSupport.on_load(:action_controller) do
        include RouteTranslator::CoreExt::ControllerPatch
      end
    end


    initializer 'route_translator.patch' do
      mapper_patch = RouteTranslator.rails_81? ? 'RouteTranslator::CoreExt::MapperPatch81' : 'RouteTranslator::CoreExt::MapperPatch'
      ActionDispatch::Routing::Mapper.prepend(mapper_patch.constantize)
    end

  end
end
