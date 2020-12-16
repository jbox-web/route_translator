# RouteTranslator

[![GitHub license](https://img.shields.io/github/license/jbox-web/route_translator.svg)](https://github.com/jbox-web/route_translator/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/jbox-web/route_translator.svg)](https://github.com/jbox-web/route_translator/releases/latest)
[![CI](https://github.com/jbox-web/route_translator/workflows/CI/badge.svg)](https://github.com/jbox-web/route_translator/actions)

RouteTranslator is a gem to allow you to manage the translations of your Rails application routes with a simple dictionary format.

It started as a rewrite of the awesome [route_translator](https://github.com/enriclluelles/route_translator) plugin by Geremia Taglialatela to [keep support of Rails engines](https://github.com/enriclluelles/route_translator/issues/178).

Right now it works with Rails 5.2 and Rails 6.x.

## Installation

Put this in your `Gemfile` :

```ruby
git_source(:github){ |repo_name| "https://github.com/#{repo_name}.git" }

gem 'route_translator', github: 'jbox-web/route_translator', tag: '1.0.0'
```

then run `bundle install`.


## Usage

1. First configure RouteTranslator in Rails application

```ruby
module Dummy
  class Application < Rails::Application
    # Extend application class to add .add_route_translator_for method
    extend RouteTranslator::Railtie::Localized

    # Declare our locales as usual
    config.i18n.available_locales = %i[fr en es pt]
    config.i18n.default_locale    = :fr
    config.i18n.fallbacks         = [:fr, { en: %i[en fr], es: %i[es fr], pt: %i[pt es fr] }]

    # Configure RouteTranslator
    add_route_translator_for(:main_site, {
      default_locale:    :fr,
      available_locales: %i[fr es pt en],
    })
  end
end
```

Here `:main_site` is just an ID to store RouteTranslator config for the current Rails application.

It's mainly useful when you have Rails engines in your application (see below), but still, you have to give one.

2. Configure your `ApplicationController`

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Configure RouteTranslator
  localized :main_site
end
```

3. Localize your routes

```ruby
Rails.application.routes.draw do
  root 'welcome#index'

  resources :posts

  localized(:main_site) do
    get 'about', to: 'pages#about', as: :about
  end

end
```

4. And add the translations to your locale files, for example :

```yml
en:
  routes:
    about: about

fr:
  routes:
    about: a-propos
```

5. Your routes are now translated! Here's the output of your `bin/rails routes` :

Before :

```sh
    Prefix Verb   URI Pattern                 Controller#Action
      root GET    /                           welcome#index
     posts GET    /posts(.:format)            posts#index
           POST   /posts(.:format)            posts#create
  new_post GET    /posts/new(.:format)        posts#new
 edit_post GET    /posts/:id/edit(.:format)   posts#edit
      post GET    /posts/:id(.:format)        posts#show
           PATCH  /posts/:id(.:format)        posts#update
           PUT    /posts/:id(.:format)        posts#update
           DELETE /posts/:id(.:format)        posts#destroy
     about GET    /about(.:format)            pages#about
```

After :

```sh
    Prefix Verb   URI Pattern                 Controller#Action
      root GET    /                           welcome#index
     posts GET    /posts(.:format)            posts#index
           POST   /posts(.:format)            posts#create
  new_post GET    /posts/new(.:format)        posts#new
 edit_post GET    /posts/:id/edit(.:format)   posts#edit
      post GET    /posts/:id(.:format)        posts#show
           PATCH  /posts/:id(.:format)        posts#update
           PUT    /posts/:id(.:format)        posts#update
           DELETE /posts/:id(.:format)        posts#destroy
  about_fr GET    /a-propos(.:format)         pages#about {:locale=>"fr"}
  about_es GET    /es/sobre(.:format)         pages#about {:locale=>"es"}
  about_pt GET    /pt/quem-e(.:format)        pages#about {:locale=>"pt"}
  about_en GET    /en/about(.:format)         pages#about {:locale=>"en"}
```

Note that only the routes inside a localized block are translated.


## Options

Accepted options for `add_route_translator_for` :

Options              | Default value            | Description
---------------------|--------------------------|------------
`:default_locale`    | `I18n.default_locale`    | RouteTranslator adds the locale to all generated route paths, except for the default locale.
`:available_locales` | `I18n.available_locales` | Limits the locales for which URLs should be generated for. Accepts an array of strings or symbols.
`:locale_param_key`  | `:locale`                | The param key used to set the locale to the newly generated routes.
`:disable_fallback`  | `false`                  | Creates routes only for locales that have translations. For example, if we have /examples and a translation is not provided for es, the route helper of examples_es will not be created.


## I18n

If you want to set `I18n.locale` from the url parameter locale, add the following line in your `ApplicationController` :

```ruby
around_action :set_locale_from_params
```

**Note :** you might be tempted to use `before_action` instead of `around_action` : just don't. That could lead to [thread-related issues](https://github.com/rails/rails/pull/34356).

If you use engines don't forget to add it in your engine `ApplicationController` (See: https://github.com/rails/rails/pull/34356#issuecomment-435110862)


## With Rails engines

It's the same procedure that applies for Rails engine :

1. First configure RouteTranslator in your Rails engine

```ruby
module Bar
  class Engine < ::Rails::Engine
    isolate_namespace Bar
    # Extend application class to add .add_route_translator_for method
    extend RouteTranslator::Railtie::Localized

    # Configure RouteTranslator
    add_route_translator_for(:bar_engine, {
      default_locale:    :es,
      available_locales: %i[es pt en],
    })
  end
end
```

2. Configure your Rails engine `ApplicationController`

```ruby
module Bar
  class ApplicationController < ActionController::Base
    layout 'bar/application'

    # Configure RouteTranslator
    localized :bar_engine
  end
end
```

3. Localize your routes

```ruby
Bar::Engine.routes.draw do
  root 'welcome#index'

  localized(:bar_engine) do
    get 'about',   to: 'pages#about', as: :about
    get 'unnamed', to: 'pages#unnamed'

    get 'people.:format', to: 'people#index'

    resources :products
  end
end
```

4. Mount your engine in Rails application :

```ruby
Rails.application.routes.draw do
  root 'welcome#index'

  localized(:main_site) do
    get 'about', to: 'pages#about', as: :about
  end

  mount Bar::Engine, at: '/bar', as: 'bar_site'
end
```


## Namespaces

You can translate a namespace route by either its `name` or `path` option :

1. Wrap the namespaces that you want to translate inside a `localized` block:

```ruby
Rails.application.routes.draw do
  localized(:main_site) do
    namespace :admin do
      resources :cars, only: :index
    end

    namespace :sold_cars, path: :sold do
      resources :cars, only: :index
    end
  end
end
```

2. And add the translations to your locale files, for example:

```yml
es:
  routes:
    admin: administrador
    cars: coches
    new: nuevo
    sold: vendidos

fr:
  routes:
    admin: administrateur
    cars: voitures
    new: nouveau
    sold: vendues
```

3. Your namespaces are translated! Here's the output of your `bin/rails routes` :

```sh
             Prefix Verb URI Pattern                           Controller#Action
      admin_cars_fr GET  /fr/administrateur/voitures(.:format) admin/cars#index {:locale=>"fr"}
      admin_cars_es GET  /es/administrador/coches(.:format)    admin/cars#index {:locale=>"es"}
      admin_cars_en GET  /admin/cars(.:format)                 admin/cars#index {:locale=>"en"}
  sold_cars_cars_fr GET  /fr/vendues/voitures(.:format)        sold_cars/cars#index {:locale=>"fr"}
  sold_cars_cars_es GET  /es/vendidos/coches(.:format)         sold_cars/cars#index {:locale=>"es"}
  sold_cars_cars_en GET  /sold/cars(.:format)                  sold_cars/cars#index {:locale=>"en"}
```


## Inflections

At the moment inflections are not supported, but you can use the following workaround :

```ruby
localized(:main_site) do
  resources :categories, path_names: { new: 'new_category' }
end
```

```yml
en:
  routes:
    category: category
    new_category: new

es:
  routes:
    category: categoria
    new_category: nueva
```

```sh
          Prefix Verb   URI Pattern                       Controller#Action
   categories_es GET    /es/categorias(.:format)          categories#index {:locale=>"es"}
   categories_en GET    /categories(.:format)             categories#index {:locale=>"en"}
                 POST   /es/categorias(.:format)          categories#create {:locale=>"es"}
                 POST   /categories(.:format)             categories#create {:locale=>"en"}
 new_category_es GET    /es/categorias/nueva(.:format)    categories#new {:locale=>"es"}
 new_category_en GET    /categories/new(.:format)         categories#new {:locale=>"en"}
edit_category_es GET    /es/categorias/:id/edit(.:format) categories#edit {:locale=>"es"}
edit_category_en GET    /categories/:id/edit(.:format)    categories#edit {:locale=>"en"}
     category_es GET    /es/categorias/:id(.:format)      categories#show {:locale=>"es"}
     category_en GET    /categories/:id(.:format)         categories#show {:locale=>"en"}
                 PATCH  /es/categorias/:id(.:format)      categories#update {:locale=>"es"}
                 PATCH  /categories/:id(.:format)         categories#update {:locale=>"en"}
                 PUT    /es/categorias/:id(.:format)      categories#update {:locale=>"es"}
                 PUT    /categories/:id(.:format)         categories#update {:locale=>"en"}
                 DELETE /es/categorias/:id(.:format)      categories#destroy {:locale=>"es"}
                 DELETE /categories/:id(.:format)         categories#destroy {:locale=>"en"}
```


## Notes

Wrapping a mount within `localized()` is not supported.

IMHO doing this is a non-sense (unless you explain why I'm wrong with a real life example), so don't do it.

```ruby
Rails.application.routes.draw do
  root 'welcome#index'

  localized(:main_site) do
    get 'about', to: 'pages#about', as: :about
    mount Bar::Engine, at: '/bar', as: 'bar_site'
  end
end
```


## Development

The specs embeds a dummy application with some [real life example](/spec/dummy/config/routes.rb).

To test it :

```sh
$ echo "127.0.0.1 main-domain.local foo-domain.local bar-domain.local" >> /etc/hosts
$ bundle install
$ cd spec/dummy
$ bin/rails s
```

Open your navigator on :

* http://main-domain.local:3000/
* http://foo-domain.local:3000/
* http://bar-domain.local:3000/
