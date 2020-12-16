# frozen_string_literal: true

Rails.application.routes.draw do
  constraints(MainDomain) do
    root 'welcome#index'

    resources :posts

    localized(:main_site) do
      get 'about', to: 'pages#about', as: :about

      resources :categories, path_names: { new: 'new_category' }

      namespace :admin do
        resources :cars, only: :index
      end

      namespace :sold_cars, path: :sold do
        resources :cars, only: :index
      end
    end

    mount Baz::Engine, at: '/baz', as: 'baz_site'
  end

  constraints(FooDomain) do
    mount Foo::Engine, at: '/', as: 'foo_site'
  end

  constraints(BarDomain) do
    mount Bar::Engine, at: '/', as: 'bar_site'
  end
end
