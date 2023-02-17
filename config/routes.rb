Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :goals, except: [:show, :update] do
        resources :stats, only: :update 
      end
    end
  end
end
