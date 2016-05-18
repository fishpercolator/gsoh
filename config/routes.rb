Rails.application.routes.draw do
  namespace :admin do
    resources :questions, :answers, :areas, :features, :users

    root to: "questions#index"
  end

  devise_for :users, controllers: { registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" }
  
  resources :answers
  resources :matches, only: [:index, :show], param: :area do
    get :all_areas, on: :collection
  end
  resources :pages
  
  root to: 'home#index'
end
