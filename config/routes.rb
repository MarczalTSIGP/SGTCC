Rails.application.routes.draw do
  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code, as: 'error_' + code
  end

  devise_for :professors

  root to: 'home#index'

  as :professor do
    get '/professors/edit' => 'professors/registrations#edit',
        :as => 'edit_professor_registration'

    put '/professors' => 'professors/registrations#update',
        :as => 'professor_registration'
  end

  authenticate :professor do
    namespace :professors do
      root to: 'dashboard#index'
      resources :academics
    end
  end
end
