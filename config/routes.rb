Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#show'

  resources :profiles, only: [ :new, :destroy, :show, :index ]

  post '/profiles', to: 'profiles#create'
end
