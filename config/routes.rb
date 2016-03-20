Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users
  root 'pages#home'

  namespace :api, defaults: {format: :json}, constraints: {subdomain: "api"}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, except: [:new, :edit]
    end
  end
end
