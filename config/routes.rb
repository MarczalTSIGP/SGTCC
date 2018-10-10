Rails.application.routes.draw do
  devise_for :professors

  root to: 'home#index'

  as :professor do
    get '/professors/edit' => 'professors/registrations#edit', :as => 'edit_professor_registration'
    put '/professors' => 'professors/registrations#update', :as => 'professor_registration'
  end

  authenticate :professor do
    namespace :professors do
      root to: 'dashboard#index'
    end
  end
end
