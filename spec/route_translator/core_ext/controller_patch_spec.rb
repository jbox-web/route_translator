# frozen_string_literal: true

require 'spec_helper'

# The patch is included into every ActionController::Base at boot, so a bare
# subclass inherits it without ever calling `localized`. Its `localized_engine`
# is then nil and `route_translator` resolves to nil, which must be handled
# gracefully (no locale switching, no crash).
RSpec.describe RouteTranslator::CoreExt::ControllerPatch do
  subject(:controller) { Class.new(ActionController::Base).new }

  describe '#set_locale_from_params without a configured engine' do
    it 'yields without altering I18n.locale' do
      ran = false

      I18n.with_locale(:fr) do
        controller.send(:set_locale_from_params) { ran = true }
        expect(I18n.locale).to eq :fr
      end

      expect(ran).to be true
    end
  end
end
