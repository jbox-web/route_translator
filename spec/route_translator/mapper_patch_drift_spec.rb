# frozen_string_literal: true

require 'spec_helper'

# Guards against silent drift of the verbatim copy of Rails' private #add_route
# body living in MapperPatch / MapperPatch81. For the default locale with no
# translation available, a localized route must be structurally identical to the
# same route drawn by vanilla Rails — same path spec, verb, required parts and
# controller/action defaults. If a Rails upgrade changes #add_route and the copy
# is not resynced, this comparison breaks.
RSpec.describe 'MapperPatch does not drift from Rails #add_route', type: :routing do
  before do
    RouteTranslator.add_translator(:drift_test, default_locale: :en, available_locales: [:en])
  end

  def last_route(&block)
    set = ActionDispatch::Routing::RouteSet.new
    set.draw(&block)
    set.routes.routes.last
  end

  let(:vanilla) do
    last_route do
      get 'widgets/:id', to: 'widgets#show', as: :widget, constraints: { id: /\d+/ }
    end
  end

  let(:localized) do
    last_route do
      localized(:drift_test) do
        get 'widgets/:id', to: 'widgets#show', as: :widget, constraints: { id: /\d+/ }
      end
    end
  end

  it 'keeps the same path spec for the default locale' do
    expect(localized.path.spec.to_s).to eq vanilla.path.spec.to_s
  end

  it 'keeps the same HTTP verb' do
    expect(localized.verb).to eq vanilla.verb
  end

  it 'keeps the same required parts' do
    expect(localized.required_parts).to eq vanilla.required_parts
  end

  it 'keeps the same controller/action defaults' do
    expect(localized.defaults.slice(:controller, :action)).to eq vanilla.defaults.slice(:controller, :action)
  end

  it 'preserves route constraints (segment regexps)' do
    expect(localized.constraints[:id]).to eq vanilla.constraints[:id]
  end
end
