Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, :controllers => { registrations: "professors/registrations" }

  devise_scope :user do
    get '/professors/edit' => 'professors/registrations#edit', :as => 'edit_professor_registration'
    put '/professors' => 'professors/registrations#update', :as => 'professor_registration'
  end

  authenticate :user do
    namespace :professors do
      root to: 'dashboard#index'
    end
  end
end
