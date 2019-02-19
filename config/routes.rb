Rails.application.routes.draw do
  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code, as: 'error_' + code
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  devise_for :professors, skip: [:sessions]

  root to: 'home#index'

  as :professor do
    get '/responsible/login',
        to: 'devise/sessions#new',
        as: 'new_responsible_session'

    post '/responsible/login',
         to: 'devise/sessions#create',
         as: 'responsible_session'

    delete '/responsible/logout',
           to: 'devise/sessions#destroy',
           as: 'destroy_responsible_session'

    get '/responsible/edit',
        to: 'responsible/registrations#edit',
        as: 'edit_responsible_registration'

    put '/responsible',
        to: 'responsible/registrations#update',
        as: 'responsible_registration'
  end

  authenticate :professor do
    namespace :responsible do
      root to: 'dashboard#index'
      resources :academics,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable
    end
  end
end
