# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TestEngine::WelcomeController, type: :routing do

  context 'when RouteTranslator is not configured' do
    it 'raises an error' do # rubocop:disable RSpec/ExampleLength
      expect {
        TestEngine::Engine.routes.draw do
          localized(:test_engine) do
            resources :widgets, only: [:index]
          end
        end
      }.to raise_error(RouteTranslator::TranslatorNotFound)
    end
  end

end
