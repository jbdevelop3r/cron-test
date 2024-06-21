require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  
  # get 'schedule/edit', to: 'schedules#edit', as: 'edit_schedule'
  post 'schedule/update', to: 'schedules#update', as: 'update_schedule'
  # get 'schedules', to: 'schedules#index', as: 'index_schedule'

  resources :schedules do 
    member do 
      patch :disable_job
      patch :enable_job
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # resources :schedulers
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "schedulers#index"
end
