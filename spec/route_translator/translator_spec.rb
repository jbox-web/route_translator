# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RouteTranslator::Translator do

  describe '#default_locale' do
    context 'when default_locale is not set' do
      let(:subject) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(subject.default_locale).to eq I18n.default_locale
      end
    end

    context 'when default_locale is set' do
      let(:subject) { described_class.new(:foo, default_locale: 'be') }

      it 'returns sets value' do
        expect(subject.default_locale).to eq 'be'
      end
    end
  end

  describe '#available_locales' do
    context 'when available_locales is not set' do
      let(:subject) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(subject.available_locales).to eq I18n.available_locales
      end
    end

    context 'when available_locales is set' do
      let(:subject) { described_class.new(:foo, available_locales: ['be']) }

      it 'returns sets value' do
        expect(subject.available_locales).to eq ['be']
      end
    end
  end

  describe '#locale_param_key' do
    context 'when locale_param_key is not set' do
      let(:subject) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(subject.locale_param_key).to eq :locale
      end
    end

    context 'when locale_param_key is set' do
      let(:subject) { described_class.new(:foo, locale_param_key: :lang) }

      it 'returns sets value' do
        expect(subject.locale_param_key).to eq :lang
      end
    end
  end

  describe '#disable_fallback' do
    context 'when disable_fallback is not set' do
      let(:subject) { described_class.new(:foo) }

      it 'fallbacks to default' do
        expect(subject.disable_fallback).to be nil
      end
    end

    context 'when disable_fallback is set' do
      let(:subject) { described_class.new(:foo, disable_fallback: true) }

      it 'returns sets value' do
        expect(subject.disable_fallback).to be true
      end
    end
  end

end
