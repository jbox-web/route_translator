# frozen_string_literal: true

module RouteTranslator
  class Translator

    attr_reader :engine, :settings

    def initialize(engine, settings = {})
      @engine   = engine
      @settings = settings
    end


    def default_locale
      @default_locale ||= settings[:default_locale] || I18n.default_locale
    end


    def available_locales
      @available_locales ||= settings[:available_locales] || I18n.available_locales
    end


    def locale_param_key
      @locale_param_key ||= settings[:locale_param_key] || :locale
    end


    def disable_fallback
      @disable_fallback ||= settings[:disable_fallback]
    end


    def translations_for(route)
      RouteTranslator::RoutesHelper.add(route.name, route.route_set.named_routes, engine)

      available_locales.each do |locale|
        translated_path = translate_path(route.path, locale, route.scope)
        next unless translated_path

        translated_name                = translate_name(route.name, locale, route.route_set.named_routes.names)
        translated_options_constraints = translate_options_constraints(route.options_constraints, locale)
        translated_options             = translate_options(route.options, locale)

        yield locale, translated_name, translated_path, translated_options_constraints, translated_options
      end
    end


    def route_name_for(args, old_name, suffix, kaller)
      current_locale_name = I18n.locale.to_s.underscore

      locale =
        if kaller.respond_to?("#{old_name}_native_#{current_locale_name}_#{suffix}")
          "native_#{current_locale_name}"
        elsif kaller.respond_to?("#{old_name}_#{current_locale_name}_#{suffix}")
          current_locale_name
        else
          default_locale.to_s.underscore
        end

      "#{old_name}_#{locale}_#{suffix}"
    end


    private


      def translate_path(path, locale, scope)
        do_translate_path(path, locale, scope)
      rescue I18n::MissingTranslationData => e
        raise e unless disable_fallback
      end


      FINAL_OPTIONAL_SEGMENTS = %r{(\([^\/]+\))$}.freeze
      private_constant :FINAL_OPTIONAL_SEGMENTS

      JOINED_SEGMENTS = %r{\/\(\/}.freeze
      private_constant :JOINED_SEGMENTS


      def do_translate_path(path, locale, scope)
        new_path = path.dup

        final_optional_segments = new_path.slice!(FINAL_OPTIONAL_SEGMENTS)

        translated_segments = new_path.split('/').map do |seg|
          seg.split('.').map { |phrase| translate_segment(phrase, locale, scope) }.join('.')
        end

        translated_segments.reject!(&:empty?)

        if display_locale?(locale) && !locale_param_present?(new_path)
          translated_segments.unshift(locale_segment(locale))
        end

        joined_segments = translated_segments.join('/')

        "/#{joined_segments}#{final_optional_segments}".gsub(JOINED_SEGMENTS, '(/')
      end


      def translate_name(name, locale, named_routes_names)
        return if name.blank?

        translated_name = "#{name}_#{locale.to_s.underscore}"

        translated_name if named_routes_names.exclude?(translated_name.to_sym)
      end


      def translate_options_constraints(options_constraints, locale)
        translated_options_constraints = options_constraints.dup

        if translated_options_constraints.respond_to?(:[]=)
          translated_options_constraints[locale_param_key] = locale.to_s
        end

        translated_options_constraints
      end


      def translate_options(options, locale)
        translated_options = options.dup

        if translated_options.exclude?(locale_param_key)
          translated_options[locale_param_key] = sanitize(locale)
        end

        translated_options
      end


      SEGMENT_PART = /(\()$/.freeze
      private_constant :SEGMENT_PART

      # rubocop:disable Metrics/CyclomaticComplexity
      def translate_segment(segment, locale, scope)
        return segment if segment.empty?

        if segment.starts_with?(':')
          named_param, hyphenized = segment.split('-', 2)
          return "#{named_param}-#{translate(hyphenized, locale, scope)}" if hyphenized
        end

        return segment if segment.starts_with?('(') || segment.starts_with?('*') || segment.include?(':')

        appended_part = segment.slice!(SEGMENT_PART)
        str = translatable_segment(segment)

        (translate_string(str, locale, scope) || segment) + appended_part.to_s
      end
      # rubocop:enable Metrics/CyclomaticComplexity


      TRANSLATABLE_SEGMENT = /^([-_a-zA-Z0-9]+)(\()?/.freeze
      private_constant :TRANSLATABLE_SEGMENT

      def translatable_segment(segment)
        matches = TRANSLATABLE_SEGMENT.match(segment)
        matches[1] if matches.present?
      end


      def translate_string(str, locale, scope)
        sanitized_locale = sanitize(locale)
        translated_resource = translate_resource(str, sanitized_locale, scope)

        Addressable::URI.normalize_component translated_resource
      end


      def translate_resource(str, locale, scope)
        handler = proc { |exception| exception }
        opts    = { locale: locale, scope: scope }

        if I18n.t(str, **opts.merge(exception_handler: handler)).is_a?(I18n::MissingTranslation)
          I18n.t(str, **opts.merge(fallback_options(str, locale)))
        else
          I18n.t(str, **opts)
        end
      end


      def display_locale?(locale)
        !default_locale?(locale)
      end


      def default_locale?(locale)
        locale.to_sym == default_locale.to_sym
      end


      def sanitize(locale)
        locale.to_s.gsub('native_', '')
      end


      def locale_segment(locale)
        locale.to_s.downcase
      end


      def locale_param_present?(path)
        path.split('/').include? ":#{locale_param_key}"
      end


      def fallback_options(str, locale)
        if disable_fallback && locale.to_sym != default_locale.to_sym
          { scope: :routes, fallback: true }
        else
          { scope: :routes, default: str }
        end
      end

  end
end
