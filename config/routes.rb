Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'equations#home'
  get "equation", to: "equations#start"
  get "equation/new", to: "equations#new"
  post "equation/score", to: "equations#score"
end
