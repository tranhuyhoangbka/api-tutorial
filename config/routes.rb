Rails.application.routes.draw do
  root 'pages#home'

  namespace :api, defaults: {format: :json}, constraints: {subdomain: "api"}, path: "/" do

  end
end
