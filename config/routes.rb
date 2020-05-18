Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users

  get '/friendships/:id', to: 'friendships#create', as: 'new_friendship'
  put '/friendships/:id', to: 'friendships#update', as: 'friendship'
  delete '/friendships/:id', to: 'friendships#destroy', as: nil
  delete '/friendships/reject/:id', to: 'friendships#reject', as: 'friendship_reject'
  resources :friendships, only: [:index]

  resources :users, only: %i[index show]
  resources :posts, only: %i[index create] do
    resources :comments, only: [:create]
    resources :likes, only: %i[create destroy]
  end
end
