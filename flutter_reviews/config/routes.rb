Rails.application.routes.draw do
  get "dashboard/show"
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token
  get "books_by/:author", to: "books_by#index", as: :books_by_author
  resources :books, param: :id do  
    resources :reviews do
      resources :likes, only: [ :create, :destroy ], param: :id
    end
  end
  resources :books_by, only: [:index]
  resources :users, only: [ :new, :create, :show, :edit, :update ], param: :id
  get "search", to: "books#index"
  get "users/new"
  get "users/create"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "dashboard#show"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
