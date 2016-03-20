Rails.application.routes.draw do
  root 'pages#home'

  namespace :api, defaults: {format: :json}, constraints: {subdomain: "api"}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

    end
  end
end
