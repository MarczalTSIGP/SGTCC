Rails.application.routes.draw do
  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code, as: 'error_' + code
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  devise_for :academics, skip: [:sessions]
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

  as :academic do
    get '/academics/login',
        to: 'devise/sessions#new',
        as: 'new_academics_session'

    post '/academics/login',
         to: 'devise/sessions#create',
         as: 'academics_session'

    delete '/academics/logout',
           to: 'devise/sessions#destroy',
           as: 'destroy_academics_session'

    get '/academics/edit',
        to: 'academics/registrations#edit',
        as: 'edit_academics_registration'

    put '/academics',
        to: 'academics/registrations#update',
        as: 'academics_registration'
  end

  authenticate :professor do
    namespace :responsible do
      root to: 'dashboard#index'

      resources :academics,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      get 'academics/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'academics#index',
          as: 'academics_search'
    end
  end

  authenticate :academic do
    namespace :academics do
      root to: 'dashboard#index'
    end
  end
end
