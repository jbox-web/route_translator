# frozen_string_literal: true

require 'spec_helper'

# The patch is included into every ActionController::Base at boot, so a bare
# subclass inherits it without ever calling `localized`. Its `localized_engine`
# is then nil and `route_translator` resolves to nil, which must be handled
# gracefully (no locale switching, no crash).
RSpec.describe RouteTranslator::CoreExt::ControllerPatch do
  # A bare ActionController::Base subclass (not ApplicationController) is required
  # here: it inherits the patch without ever calling `localized`, exercising the
  # nil-engine path. Subclassing ApplicationController would defeat the test.
  subject(:controller) { Class.new(ActionController::Base).new } # rubocop:disable Rails/ApplicationController

  describe '#set_locale_from_params without a configured engine' do
    # Both expectations are the point: the block runs AND the locale is left intact.
    it 'yields without altering I18n.locale' do # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      ran = false

      I18n.with_locale(:fr) do
        controller.send(:set_locale_from_params) { ran = true }
        expect(I18n.locale).to eq :fr
      end

      expect(ran).to be true
    end
  end
end
