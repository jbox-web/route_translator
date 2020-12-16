# frozen_string_literal: true

Bar::Engine.routes.draw do
  root 'welcome#index'

  localized(:bar_engine) do
    get 'about',   to: 'pages#about', as: :about
    get 'unnamed', to: 'pages#unnamed'

    get 'people.:format', to: 'people#index'

    resources :products
  end
end
