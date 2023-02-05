Rails.application.routes.draw do
  #  get 'translations/index'
  #  get 'translations/translate'
  #  post 'translations/translate', as: :translate
  get 'sessions/new'
  
  root "static_pages#home"
  get  "/help",    to: "static_pages#help"
  get  "/about",   to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "static_pages/translate", to: "static_pages#translate"
  post 'static_pages/translate', as: :translate
  get  "/signup", to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
end
