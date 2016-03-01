Rails.application.routes.draw do

  namespace :admin do
    resources :questions, :answers, :areas, :features, :users

    root to: "questions#index"
  end

  devise_for :users
  
  resources :questions, only: [:index] do
    get :answer, on: :collection
  end
  resources :answers, only: [:create, :update, :delete]
  
  root to: 'pages#show', id: 'index'
end
