# frozen_string_literal: true

require 'spec_helper'

# Exercises the runtime locale switching provided by
# RouteTranslator::CoreExt::ControllerPatch#set_locale_from_params.
# The `root` route lives OUTSIDE the `localized` block, so it carries no
# `:locale` route default and the query string flows into params[:locale].
RSpec.describe 'set_locale_from_params', type: :request do
  # The welcome view renders "I18n current locale : <locale>", so the response
  # body reflects the locale that was active *during* the action.
  def current_locale
    response.body[/current locale : (\w+)/, 1]
  end

  context 'when no locale param is given' do
    before { get 'http://main-domain.local/' }

    it { expect(response).to have_http_status(:ok) }
    it { expect(current_locale).to eq 'fr' }
  end

  context 'when a valid locale param is given' do
    before { get 'http://main-domain.local/', params: { locale: 'es' } }

    it { expect(response).to have_http_status(:ok) }
    it { expect(current_locale).to eq 'es' }
  end

  context 'when an unavailable locale param is given' do
    before { get 'http://main-domain.local/', params: { locale: 'zzz' } }

    it 'does not raise' do
      expect(response).to have_http_status(:ok)
    end

    it 'falls back to the default locale' do
      expect(current_locale).to eq 'fr'
    end
  end

  it 'restores the previous I18n.locale after the request' do
    I18n.with_locale(:en) do
      get 'http://main-domain.local/', params: { locale: 'es' }
      expect(I18n.locale).to eq :en
    end
  end
end
