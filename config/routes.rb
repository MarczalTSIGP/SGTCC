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

      resources :base_activities,
                constraints: { id: /[0-9]+/ }

      resources :activities,
                constraints: { id: /[0-9]+/ }

      resources :calendars,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      get 'activities/tcc/1', to: 'activities#tcc_one', as: 'activities_tcc_one'
      get 'activities/tcc/2', to: 'activities#tcc_two', as: 'activities_tcc_two'

      get 'base_activities/tcc/1', to: 'base_activities#tcc_one', as: 'base_activities_tcc_one'
      get 'base_activities/tcc/2', to: 'base_activities#tcc_two', as: 'base_activities_tcc_two'

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

      get 'base_activities/tcc/1/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'base_activities#tcc_one',
          as: 'base_activities_search_tcc_one'

      get 'base_activities/tcc/2/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'base_activities#tcc_two',
          as: 'base_activities_search_tcc_two'
    end

    namespace :professors do
      root to: 'dashboard#index'
    end
  end

  #========================================
  # Professors
  #========================================
  devise_for :professors, skip: [:sessions]

  as :professor do
    get '/professors/login',
        to: 'devise/sessions#new',
        as: 'new_professor_session'

    post '/professors/login',
         to: 'devise/sessions#create',
         as: 'professor_session'

    delete '/professors/logout',
           to: 'devise/sessions#destroy',
           as: 'destroy_professor_session'

    get '/professors/edit',
        to: 'professors/registrations#edit',
        as: 'edit_professor_registration'

    put '/professors',
        to: 'professors/registrations#update',
        as: 'professor_registration'
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
         as: 'academic_session'

    delete '/academics/logout',
           to: 'devise/sessions#destroy',
           as: 'destroy_academic_session'

    get '/academics/edit',
        to: 'academics/registrations#edit',
        as: 'edit_academic_registration'

    put '/academics',
        to: 'academics/registrations#update',
        as: 'academic_registration'
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
           as: 'destroy_external_member_session'

    get '/external_members/edit',
        to: 'external_members/registrations#edit',
        as: 'edit_external_member_registration'

    put '/external_members',
        to: 'external_members/registrations#update',
        as: 'external_member_registration'
  end

  authenticate :external_member do
    namespace :external_members do
      root to: 'dashboard#index'
    end
  end
end
