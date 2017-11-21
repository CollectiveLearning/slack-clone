Rails.application.routes.draw do
  namespace :v1 do
    jsonapi_resources :users
    jsonapi_resources :channels
    jsonapi_resources :messages
    jsonapi_resources :subscriptions
    jsonapi_resources :authentications, only: [:create]
  end
end
