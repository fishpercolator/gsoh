Rails.application.routes.draw do

  namespace :admin do
    resources :questions, :answers, :areas, :features, :users

    root to: "questions#index"
  end

  devise_for :users
  
  resources :answers
  resources :matches, only: [:index, :show], param: :area
  
  root to: 'pages#show', id: 'index'
end
