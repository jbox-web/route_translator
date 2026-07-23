# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RouteTranslator::Translator do

  describe '#default_locale' do
    context 'when default_locale is not set' do
      subject(:translator) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(translator.default_locale).to eq I18n.default_locale
      end
    end

    context 'when default_locale is set' do
      subject(:translator) { described_class.new(:foo, default_locale: 'be') }

      it 'returns sets value' do
        expect(translator.default_locale).to eq 'be'
      end
    end
  end

  describe '#available_locales' do
    context 'when available_locales is not set' do
      subject(:translator) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(translator.available_locales).to eq I18n.available_locales
      end
    end

    context 'when available_locales is set' do
      subject(:translator) { described_class.new(:foo, available_locales: ['be']) }

      it 'returns sets value' do
        expect(translator.available_locales).to eq ['be']
      end
    end
  end

  describe '#locale_param_key' do
    context 'when locale_param_key is not set' do
      subject(:translator) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(translator.locale_param_key).to eq :locale
      end
    end

    context 'when locale_param_key is set' do
      subject(:translator) { described_class.new(:foo, locale_param_key: :lang) }

      it 'returns sets value' do
        expect(translator.locale_param_key).to eq :lang
      end
    end
  end

  describe '#disable_fallback' do
    context 'when disable_fallback is not set' do
      subject(:translator) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(translator.disable_fallback).to be false
      end
    end

    context 'when disable_fallback is set to true' do
      subject(:translator) { described_class.new(:foo, disable_fallback: true) }

      it 'returns sets value' do
        expect(translator.disable_fallback).to be true
      end
    end

    context 'when disable_fallback is set to false' do
      subject(:translator) { described_class.new(:foo, disable_fallback: false) }

      it 'returns sets value' do
        expect(translator.disable_fallback).to be false
      end
    end
  end

  describe '#route_name_for' do
    subject(:translator) { described_class.new(:main_site, default_locale: :fr, available_locales: %i[fr es]) }

    context 'when the caller exposes a native helper for the current locale' do
      let(:kaller) { Class.new { def about_native_es_path; end }.new }

      it 'prefers the native localized helper name' do
        I18n.with_locale(:es) do
          expect(translator.route_name_for([], 'about', 'path', kaller)).to eq 'about_native_es_path'
        end
      end
    end

    context 'when the caller exposes a helper for the current locale' do
      let(:kaller) { Class.new { def about_es_path; end }.new }

      it 'returns the current-locale helper name' do
        I18n.with_locale(:es) do
          expect(translator.route_name_for([], 'about', 'path', kaller)).to eq 'about_es_path'
        end
      end
    end

    context 'when the caller exposes no localized helper' do
      let(:kaller) { Object.new }

      it 'falls back to the default-locale helper name' do
        I18n.with_locale(:es) do
          expect(translator.route_name_for([], 'about', 'path', kaller)).to eq 'about_fr_path'
        end
      end
    end
  end

  describe '#translate_path (fallback on missing translation)' do
    subject(:translator) { described_class.new(:main_site, disable_fallback: disable_fallback) }

    before do
      allow(translator).to receive(:do_translate_path)
        .and_raise(I18n::MissingTranslationData.new(:es, 'routes.missing', {}))
    end

    context 'when disable_fallback is false' do
      let(:disable_fallback) { false }

      it 're-raises the missing translation error' do
        expect { translator.send(:translate_path, '/missing', :es, %i[routes controllers]) }
          .to raise_error(I18n::MissingTranslationData)
      end
    end

    context 'when disable_fallback is true' do
      let(:disable_fallback) { true }

      it 'swallows the error and returns nil' do
        expect(translator.send(:translate_path, '/missing', :es, %i[routes controllers])).to be_nil
      end
    end
  end

  describe '#fallback_options' do
    context 'when disable_fallback is true on a non-default locale' do
      subject(:translator) { described_class.new(:main_site, disable_fallback: true, default_locale: :fr) }

      it 'requests the routes scope without a default value' do
        expect(translator.send(:fallback_options, 'about', :es)).to eq(scope: :routes, fallback: true)
      end
    end

    context 'when fallback is allowed' do
      subject(:translator) { described_class.new(:main_site, disable_fallback: false, default_locale: :fr) }

      it 'defaults back to the untranslated segment' do
        expect(translator.send(:fallback_options, 'about', :es)).to eq(scope: :routes, default: 'about')
      end
    end
  end

  describe '#translate_segment (hyphenated dynamic segment)' do
    subject(:translator) { described_class.new(:main_site) }

    it 'keeps the leading param and translates the segment after the hyphen' do
      expect(translator.send(:translate_segment, ':id-category', :es, %i[routes controllers]))
        .to eq ':id-categoria'
    end
  end

  describe '#translate_options (locale injection)' do
    subject(:translator) { described_class.new(:main_site) }

    it 'injects the locale when the options carry none' do
      expect(translator.send(:translate_options, {}, :es)).to eq(locale: 'es')
    end

    it 'leaves an explicit locale option untouched' do
      expect(translator.send(:translate_options, { locale: 'preset' }, :es)).to eq(locale: 'preset')
    end
  end

  describe '#translations_for' do
    subject(:translator) do
      described_class.new(:main_site, default_locale: :fr, available_locales: %i[fr es])
    end

    # A controller-less mapping exercises Route's fallback scope ([:routes, :controllers]).
    let(:mapping)      { double('mapping', defaults: {}) }
    let(:named_routes) { double('named_routes', names: []) }
    let(:route_set)    { double('route_set', named_routes: named_routes) }
    let(:route)        { RouteTranslator::Route.new(route_set, '/foo', nil, {}, {}, mapping) }

    before do
      allow(translator).to receive(:translate_path).and_call_original
      allow(translator).to receive(:translate_path).with('/foo', :es, anything).and_return(nil)
      allow(translator).to receive(:translate_path).with('/foo', :fr, anything).and_return('/foo')
    end

    it 'skips locales whose translated path is nil' do
      yielded = []
      translator.translations_for(route) { |locale, *| yielded << locale }
      expect(yielded).to eq [:fr]
    end
  end

end
