Rails.application.routes.draw do
  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code, as: 'error_' + code
  end

  devise_for :admins

  root to: 'home#index'

  as :admin do
    get '/admins/edit' => 'admins/registrations#edit',
        :as => 'edit_admin_registration'

    put '/admins' => 'admins/registrations#update',
        :as => 'admin_registration'
  end

  authenticate :admin do
    namespace :admins do
      root to: 'dashboard#index'
      resources :academics
    end
  end
end
