Rails.application.routes.draw do
  namespace :admin do
    resources :areas, :features, :questions, :users

    root to: "areas#index"
  end

  devise_for :users
  resources :questions
  root to: 'pages#show', id: 'index'
end
