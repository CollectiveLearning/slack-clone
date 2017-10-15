Rails.application.routes.draw do
  use_doorkeeper

  namespace :v1 do
    jsonapi_resources :users
    jsonapi_resources :channels
    jsonapi_resources :messages
    jsonapi_resources :subscriptions
  end
end
