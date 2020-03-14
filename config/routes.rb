Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :games, only: %i[create show] do
        resources :shots, only: :create
      end
    end
  end
end
