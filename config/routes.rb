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

      resources :orientations,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :external_members,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :institutions,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :base_activities,
                except: :index,
                constraints: { id: /[0-9]+/ }

      resources :calendars,
                except: :index,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable do
                  resources :activities
                end

      post 'calendars/activities/by-calendar',
           to: 'activities#index_by_calendar',
           as: 'calendar_activities_by_calendar'

      get 'calendars/tcc_one', to: 'calendars#tcc_one', as: 'calendars_tcc_one'
      get 'calendars/tcc_two', to: 'calendars#tcc_two', as: 'calendars_tcc_two'

      get 'base_activities/tcc_one', to: 'base_activities#tcc_one', as: 'base_activities_tcc_one'
      get 'base_activities/tcc_two', to: 'base_activities#tcc_two', as: 'base_activities_tcc_two'

      get 'orientations/tcc_one', to: 'orientations#tcc_one', as: 'orientations_tcc_one'
      get 'orientations/tcc_two', to: 'orientations#tcc_two', as: 'orientations_tcc_two'

      get 'orientations/current_tcc_one',
          to: 'orientations#current_tcc_one',
          as: 'orientations_current_tcc_one'

      get 'orientations/current_tcc_two',
          to: 'orientations#current_tcc_two',
          as: 'orientations_current_tcc_two'

      post 'orientations/(:id)/renew', to: 'orientations#renew', as: 'orientations_renew'
      post 'orientations/(:id)/cancel', to: 'orientations#cancel', as: 'orientations_cancel'

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

      get 'orientations/current_tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#current_tcc_one',
          as: 'orientations_search_current_tcc_one'

      get 'orientations/current_tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#current_tcc_two',
          as: 'orientations_search_current_tcc_two'

      get 'orientations/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#tcc_one',
          as: 'orientations_search_tcc_one'

      get 'orientations/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#tcc_two',
          as: 'orientations_search_tcc_two'

      get 'base_activities/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'base_activities#tcc_one',
          as: 'base_activities_search_tcc_one'

      get 'base_activities/tcc_two/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'base_activities#tcc_two',
          as: 'base_activities_search_tcc_two'

      get 'calendars/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'calendars#tcc_one',
          as: 'calendars_search_tcc_one'

      get 'calendars/tcc_two/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'calendars#tcc_two',
          as: 'calendars_search_tcc_two'
    end

    namespace :professors do
      root to: 'dashboard#index'

      resources :orientations,
                except: [:index, :destroy],
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :supervisions,
                only: [:show],
                constraints: { id: /[0-9]+/ }

      get 'orientations/tcc_one', to: 'orientations#tcc_one', as: 'orientations_tcc_one'
      get 'orientations/tcc_two', to: 'orientations#tcc_two', as: 'orientations_tcc_two'
      get 'orientations/history', to: 'orientations#history', as: 'orientations_history'
      get 'supervisions/history', to: 'supervisions#history', as: 'supervisions_history'

      get 'supervisions/tcc_one',
          to: 'supervisions#tcc_one',
          as: 'supervisions_tcc_one'

      get 'supervisions/tcc_two',
          to: 'supervisions#tcc_two',
          as: 'supervisions_tcc_two'

      get 'calendars/:calendar_id/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      get 'calendars/:calendar_id/activities/:id',
          to: 'activities#show',
          as: 'calendar_activity'

      get 'orientations/history/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#history',
          as: 'orientations_search_history'

      get 'orientations/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#tcc_one',
          as: 'orientations_search_tcc_one'

      get 'orientations/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#tcc_two',
          as: 'orientations_search_tcc_two'

      get 'supervisions/history/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'supervisions#history',
          as: 'supervisions_search_history'

      get 'supervisions/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'supervisions#tcc_one',
          as: 'supervisions_search_tcc_one'

      get 'supervisions/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'supervisions#tcc_two',
          as: 'supervisions_search_tcc_two'
    end

    namespace :tcc_one_professors do
      root to: 'dashboard#index'

      get 'calendars/tcc_one', to: 'calendars#tcc_one', as: 'calendars_tcc_one'

      get 'calendars/(:calendar_id)/orientations',
          to: 'orientations#by_calendar',
          as: 'calendar_orientations'

      get 'orientations/current_tcc_one',
          to: 'orientations#current_tcc_one',
          as: 'orientations_current_tcc_one'

      get 'calendars/(:calendar_id)/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      get 'calendars/(:calendar_id)/activities/:id',
          to: 'activities#show',
          as: 'calendar_activity'

      get 'calendars/(:calendar_id)/orientations/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'orientations#by_calendar',
          as: 'calendar_orientations_search'

      get 'calendars/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'calendars#tcc_one',
          as: 'calendars_search_tcc_one'

      get 'calendars/(:calendar_id)/orientations/(:id)',
          to: 'orientations#show',
          as: 'calendar_orientation'
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

      get 'calendars', to: 'calendars#index', as: 'calendars'

      get '/calendars/(:calendar_id)/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      get '/calendars/(:calendar_id)/activities/(:id)',
          to: 'activities#show',
          as: 'calendar_activity'
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

      resources :supervisions, only: [:show], constraints: { id: /[0-9]+/ }

      get 'calendars', to: 'calendars#index', as: 'calendars'

      get '/calendars/(:calendar_id)/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      get '/calendars/(:calendar_id)/activities/(:id)',
          to: 'activities#show',
          as: 'calendar_activity'

      get 'supervisions/history', to: 'supervisions#history', as: 'supervisions_history'

      get 'supervisions/tcc_one',
          to: 'supervisions#tcc_one',
          as: 'supervisions_tcc_one'

      get 'supervisions/tcc_two',
          to: 'supervisions#tcc_two',
          as: 'supervisions_tcc_two'

      get 'supervisions/history/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'supervisions#history',
          as: 'supervisions_search_history'

      get 'supervisions/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'supervisions#tcc_one',
          as: 'supervisions_search_tcc_one'

      get 'supervisions/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^\/]+} },
          to: 'supervisions#tcc_two',
          as: 'supervisions_search_tcc_two'
    end
  end
end
