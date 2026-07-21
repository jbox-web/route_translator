# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this gem does

`route_translator` rewrites your Rails routes into one route per locale, driven by
your I18n locale files. It is a rewrite of enriclluelles/route_translator focused on
keeping **Rails engine** support. Runtime deps: `rails >= 7.0`, `addressable`,
`zeitwerk`. Ruby `>= 3.2`.

## Commands

Tests, lint and tools run through the checked-in binstubs in `bin/` (bundler-wrapped):

```sh
bin/rspec                                   # full suite (against the root Gemfile)
bin/rspec spec/route_translator/translator_spec.rb        # one file
bin/rspec spec/route_translator/routing/foo_engine_spec.rb:42   # one example by line
bin/rubocop                                 # lint (config in .rubocop.yml)
bin/guard                                   # watch + auto-run specs (Guardfile)
```

Run against a specific Rails version (the CI matrix) via the Appraisal gemfiles in
`gemfiles/`:

```sh
BUNDLE_GEMFILE=gemfiles/rails_8.1.gemfile bin/rspec
BUNDLE_GEMFILE=gemfiles/rails_7.2.gemfile bin/rspec
bin/appraisal install                       # regenerate gemfiles/*.gemfile after editing Appraisals
```

Supported versions come from `Appraisals` (Rails 7.2 / 8.0 / 8.1) and the CI matrix
in `.github/workflows/ci.yml` (Ruby 3.2–4.0). Coverage is written to `coverage/`
(SimpleCov, HTML + JSON) on every `bin/rspec` run.

## Architecture

The gem works by **monkey-patching the Rails router** at boot and multiplying each
route inside a `localized` block into one localized route per available locale.

Boot wiring — `lib/route_translator/railtie.rb`:
- prepends the mapper patch onto `ActionDispatch::Routing::Mapper`;
- includes the controller patch into `ActionController` via `on_load`.

Configuration is keyed by an **engine id** (an arbitrary symbol, e.g. `:main_site`).
`RouteTranslator.add_translator(engine, opts)` stores a `Translator` in a module-level
registry; `translator_for(engine)` looks it up. Every `localized(:id)` block and every
`localized :id` controller must reference an id that was registered, or route drawing
raises `TranslatorNotFound`.

Request flow:

1. **Route drawing (`core_ext/mapper_patch*.rb`).** `localized(engine) { ... }` sets
   `@localized`/`@engine`; while set, the overridden private `add_route` reproduces the
   Rails-source body of the real `add_route` up to the `Mapping.build` call, then hands
   off to `_add_localized_route` instead of `@set.add_route`. That calls
   `Translator#translations_for`, which yields once per locale, and each yield adds a
   translated `Mapping` to the route set.

   **There are two patch variants because Rails changed `add_route`'s signature in 8.1.**
   `MapperPatch` matches Rails 7.0–8.0; `MapperPatch81` matches 8.1+ (note the extra
   `as`, `internal`, `options_mapping` params). `RouteTranslator.rails_81?` picks which
   one to prepend. **Both bodies are copied verbatim from Rails source** (the exact
   Rails tag is linked in a comment) — when bumping the supported Rails version, diff the
   upstream `add_route` and resync the copied section, and add a new patch variant rather
   than editing an existing one if the signature changes again. Only the variant matching
   the Rails version under test is loaded, so a single-gemfile run (`bin/rspec` against the
   root Gemfile → newest Rails) exercises just one patch — covering both requires running
   the full Appraisal matrix (`gemfiles/*.gemfile`), which CI does. `mapper_patch*.rb` are
   excluded from RuboCop (`.rubocop.yml`) precisely because they are verbatim Rails copies.

2. **Translation (`translator.rb`).** `translate_path` splits the path into segments and
   translates each translatable segment via `I18n.t(seg, scope: [:routes, :controllers, ...])`,
   prepending the locale segment (e.g. `/es/...`) for non-default locales, and normalizing
   with `Addressable::URI`. It also derives the localized route **name** (`about` →
   `about_es`) and injects the locale into options/constraints. `disable_fallback`,
   `default_locale`, `available_locales`, `locale_param_key` all read from the per-engine
   `settings` hash with I18n defaults.

3. **Helper aliasing (`routes_helper.rb`).** Defines the *base* helper name
   (`about_path`) as a shim that dispatches at call time to the right localized helper
   (`about_es_path`) based on `I18n.locale`, so app code keeps calling `about_path`.

4. **Runtime locale (`core_ext/controller_patch.rb`).** `localized :engine` in a
   controller stores the engine; `set_locale_from_params` (an around-ish helper) reads
   `params[locale_param_key]` and sets `I18n.locale` for the request, restoring it after.

## Tests

There is no `test/` dir — everything is RSpec under `spec/`. The suite boots a full
**dummy Rails app** (`spec/dummy/`) with a main app plus three engines (`foo`, `bar`,
`baz`, gem'd locally in `spec/dummy/engines/` and wired via `Gemfile`). Routing specs in
`spec/route_translator/routing/` assert the generated localized paths/names. When you
change translation behavior, the dummy app's `config/routes.rb` and `config/locales/*.yml`
are the fixtures to update alongside the specs.
