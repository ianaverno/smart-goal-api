Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'goals/index'
      get 'goals/create'
      get 'goals/update'
      get 'goals/destroy'
    end
  end
  namespace :api do
    namespace :v1 do
      resources :goals, except: :show
    end
  end
end
