# frozen_string_literal: true

Foo::Engine.routes.draw do
  root 'welcome#index'

  localized(:foo_engine) do
    get 'about',   to: 'pages#about', as: :about
    get 'unnamed', to: 'pages#unnamed'

    get 'people.:format', to: 'people#index'

    resources :products
  end
end
