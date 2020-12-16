# frozen_string_literal: true

Baz::Engine.routes.draw do
  root 'welcome#index'

  localized(:baz_engine) do
    get 'about',   to: 'pages#about', as: :about
    get 'unnamed', to: 'pages#unnamed'

    get 'people.:format', to: 'people#index'

    resources :products
  end
end
