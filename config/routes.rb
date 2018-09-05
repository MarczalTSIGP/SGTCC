Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users

  authenticate :user do
    namespace :professors do
      root to: 'dashboard#index'
    end
  end
end
