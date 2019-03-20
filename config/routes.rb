Rails.application.routes.draw do
  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code, as: 'error_' + code
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  root to: 'home#index'

  #========================================
  # Responsible
  #========================================
  authenticate :professor do
    namespace :responsible do
      root to: 'dashboard#index'

      resources :academics,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :professors,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :external_members,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :institutions,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      get 'academics/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'academics#index',
          as: 'academics_search'

      get 'professors/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'professors#index',
          as: 'professors_search'

      get 'external_members/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'external_members#index',
          as: 'external_members_search'

      get 'institutions/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'institutions#index',
          as: 'institutions_search'
    end
  end

  #========================================
  # Professors
  #========================================
  devise_for :professors, skip: [:sessions]
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

  #========================================
  # Academics
  #========================================
  devise_for :academics, skip: [:sessions]
  as :academic do
    get '/academics/login',
        to: 'devise/sessions#new',
        as: 'new_academic_session'

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

  authenticate :academic do
    namespace :academics do
      root to: 'dashboard#index'
    end
  end

  #========================================
  # External members
  #========================================
  devise_for :external_members, skip: [:sessions]
  as :external_member do
    get '/external_members/login',
        to: 'devise/sessions#new',
        as: 'new_external_member_session'

    post '/external_members/login',
         to: 'devise/sessions#create',
         as: 'external_members_session'

    delete '/external_members/logout',
           to: 'devise/sessions#destroy',
           as: 'destroy_external_members_session'

    get '/external_members/edit',
        to: 'external_members/registrations#edit',
        as: 'edit_external_members_registration'

    put '/external_members',
        to: 'external_members/registrations#update',
        as: 'external_members_registration'
  end

  authenticate :external_member do
    namespace :external_members do
      root to: 'dashboard#index'
    end
  end
end
