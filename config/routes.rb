Rails.application.routes.draw do
  %w[404 422 500].each do |code|
    get code, to: 'errors#show', code: code, as: "error_#{code}"
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  root to: 'site#index'

  get 'documents/images',
      to: 'documents#images',
      as: 'document_images'

  post 'documents/(:id)/mark',
       to: 'documents#mark',
       as: 'document_mark'

  post 'documents/(:id)/status',
       to: 'documents#status',
       as: 'document_status'

  get 'autenticidade/documentos',
      to: 'documents#document',
      as: 'document'

  get 'autenticidade/documentos/(:code)',
      to: 'documents#show',
      as: 'confirm_document_code'

  post 'autenticidade/documentos/(:code)',
       to: 'documents#confirm_document',
       as: 'confirm_document'

  post 'documents/(:id)/code', to: 'documents#code', as: 'document_code'
  post 'documents/(:id)/data', to: 'documents#data', as: 'document_data'
  post 'documents/(:id)/request', to: 'documents#request_data', as: 'document_request'

  post '/sidebar', to: 'site#sidebar', as: 'site_sidebar'

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

      resources :examination_boards,
                except: [:new, :create],
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :site,
                only: [:edit, :update],
                constraints: { id: /[0-9]+/ }

      resources :pages,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :images,
                except: :show,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :attached_documents,
                except: :show,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      get 'examination_boards/tcc_one/(:current_semester)',
          to: 'examination_boards#tcc_one',
          as: 'examination_boards_tcc_one',
          constraints: { current_semester: /current_semester/ }

      get 'examination_boards/tcc_one/new',
          to: 'examination_boards#new_to_tcc_one',
          as: 'examination_boards_new_tcc_one'

      post 'examination_boards/tcc_one/(:current_semester)',
           to: 'examination_boards#create_to_tcc_one',
           as: 'examination_boards_create_tcc_one',
           constraints: { current_semester: /current_semester/ }

      get 'examination_boards/tcc_two',
          to: 'examination_boards#tcc_two',
          as: 'examination_boards_tcc_two'

      get 'examination_boards/tcc_two/new',
          to: 'examination_boards#new_to_tcc_two',
          as: 'examination_boards_new_tcc_two'

      post 'examination_boards/tcc_two',
           to: 'examination_boards#create_to_tcc_two',
           as: 'examination_boards_create_tcc_two'

      post 'calendars/activities/by-calendar',
           to: 'activities#index_by_calendar',
           as: 'calendar_activities_by_calendar'

      get 'calendars/tcc_one', to: 'calendars#tcc_one', as: 'calendars_tcc_one'
      get 'calendars/tcc_two', to: 'calendars#tcc_two', as: 'calendars_tcc_two'

      get 'base_activities/tcc_one', to: 'base_activities#tcc_one', as: 'base_activities_tcc_one'
      get 'base_activities/tcc_two', to: 'base_activities#tcc_two', as: 'base_activities_tcc_two'

      get 'orientations/tcc_one', to: 'orientations#tcc_one', as: 'orientations_tcc_one'
      get 'orientations/tcc_two', to: 'orientations#tcc_two', as: 'orientations_tcc_two'

      get 'professors/(:id)/orientations/tcc_one',
          to: 'professors#tcc_one',
          as: 'professor_orientations_tcc_one'

      get 'professors/(:id)/orientations/tcc_two',
          to: 'professors#tcc_two',
          as: 'professor_orientations_tcc_two'

      put 'documents/(:id)/judgment', to: 'documents#judgment', as: 'document_judgment'

      get 'reports', to: 'dashboard#report', as: 'reports'

      get 'site/pages/order', to: 'pages#order', as: 'pages_order'
      put 'site/sidebar/update', to: 'pages#update_order', as: 'update_sidebar'

      get 'professors/available',
          to: 'professors#available',
          as: 'professors_available'

      get 'professors/unavailable',
          to: 'professors#unavailable',
          as: 'professors_unavailable'

      get 'orientations/current_tcc_one',
          to: 'orientations#current_tcc_one',
          as: 'orientations_current_tcc_one'

      get 'orientations/current_tcc_two',
          to: 'orientations#current_tcc_two',
          as: 'orientations_current_tcc_two'

      get 'orientations/migration',
          to: 'orientations_migration#index',
          as: 'orientations_migration'

      post 'orientations/(:id)/migrate',
           to: 'orientations_migration#migrate',
           as: 'orientations_migrate'

      post 'orientations/(:id)/renew', to: 'orientations#renew', as: 'orientations_renew'
      post 'orientations/(:id)/cancel', to: 'orientations#cancel', as: 'orientations_cancel'

      get 'orientations/(:id)/documents',
          to: 'orientations#documents',
          as: 'orientation_documents'

      get 'orientations/(:id)/documents/(:document_id)',
          to: 'orientations#document',
          as: 'orientation_document'

      get 'orientations/(:orientation_id)/calendars/(:calendar_id)/activities',
          to: 'orientation_activities#index',
          as: 'orientation_calendar_activities'

      # get 'orientations/(:id)/activities/(:activity_id)',
      get 'orientations/(:orientation_id)/calendars/(:calendar_id)/activities/(:id)',
          to: 'orientation_activities#show',
          as: 'orientation_calendar_activity'

      get 'academics/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'academics#index',
          as: 'academics_search'

      get 'professors/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'professors#index',
          as: 'professors_search'

      get 'professors/available/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'professors#available',
          as: 'professors_available_search'

      get 'professors/unavailable/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'professors#unavailable',
          as: 'professors_unavailable_search'

      get 'external_members/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'external_members#index',
          as: 'external_members_search'

      get 'institutions/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'institutions#index',
          as: 'institutions_search'

      get 'examination_boards/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#tcc_one',
          as: 'examination_boards_tcc_one_search'

      get 'examination_boards/tcc_two/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#tcc_two',
          as: 'examination_boards_tcc_two_search'

      get 'orientations/current_tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#current_tcc_one',
          as: 'orientations_search_current_tcc_one'

      get 'orientations/current_tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#current_tcc_two',
          as: 'orientations_search_current_tcc_two'

      get 'orientations/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#tcc_one',
          as: 'orientations_search_tcc_one'

      get 'orientations/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#tcc_two',
          as: 'orientations_search_tcc_two'

      get 'base_activities/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'base_activities#tcc_one',
          as: 'base_activities_search_tcc_one'

      get 'base_activities/tcc_two/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'base_activities#tcc_two',
          as: 'base_activities_search_tcc_two'

      get 'calendars/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'calendars#tcc_one',
          as: 'calendars_search_tcc_one'

      get 'calendars/tcc_two/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'calendars#tcc_two',
          as: 'calendars_search_tcc_two'

      get 'professors/(:id)/orientations/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'professors#tcc_one',
          as: 'professor_orientations_search_tcc_one'

      get 'professors/(:id)/orientations/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'professors#tcc_two',
          as: 'professor_orientations_search_tcc_two'

      get 'pages/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'pages#index',
          as: 'pages_search'

      get 'attached_documents/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'attached_documents#index',
          as: 'attached_documents_search'

      get 'images/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'images#index',
          as: 'images_search'
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

      resources :requests,
                except: :show,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :meetings,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :examination_boards,
                only: [:index, :show],
                constraints: { id: /[0-9]+/ }

      post 'orientations/(:id)/abandon', to: 'orientations#abandon', as: 'orientations_abandon'

      get 'meetings/orientations/(:id)',
          to: 'meetings#orientation',
          as: 'orientation_meetings'

      get 'orientations/(:id)/documents',
          to: 'orientations#documents',
          as: 'orientation_documents'

      get 'orientations/(:id)/documents/(:document_id)',
          to: 'orientations#document',
          as: 'orientation_document'

      # get 'orientations/(:id)/activities',
      get 'orientations/:orientation_id/calendars/:calendar_id/activities',
          to: 'orientation_activities#index',
          as: 'orientation_calendar_activities'

      # get 'orientations/(:id)/activities/(:activity_id)',
      get 'orientations/:orientation_id/calendars/:calendar_id/activities/:id',
          to: 'orientation_activities#show',
          as: 'orientation_calendar_activity'

      # patch 'orientations/(:id)/activities/(:activity_id)/update_judgment',
      patch 'orientations/:orientation_id/calendars/:calendar_id/activities/:id',
            to: 'orientation_activities#update_judgment',
            as: 'orientation_activity_update_judgment'

      get 'orientations/tcc_one', to: 'orientations#tcc_one', as: 'orientations_tcc_one'
      get 'orientations/tcc_two', to: 'orientations#tcc_two', as: 'orientations_tcc_two'
      get 'orientations/history', to: 'orientations#history', as: 'orientations_history'
      get 'supervisions/history', to: 'supervisions#history', as: 'supervisions_history'

      post 'documents/(:id)/sign', to: 'documents#sign', as: 'document_sign'
      get 'documents/reviewing', to: 'documents#reviewing', as: 'documents_reviewing'
      get 'documents/pending', to: 'documents#pending', as: 'documents_pending'
      get 'documents/signed', to: 'documents#signed', as: 'documents_signed'
      get 'documents/(:id)', to: 'documents#show', as: 'document'

      get 'reports/(:professor_id)', to: 'dashboard#report', as: 'reports'

      get 'supervisions/tcc_one',
          to: 'supervisions#tcc_one',
          as: 'supervisions_tcc_one'

      get 'supervisions/tcc_two',
          to: 'supervisions#tcc_two',
          as: 'supervisions_tcc_two'

      get 'supervisions/(:id)/documents',
          to: 'supervisions#documents',
          as: 'supervision_documents'

      get 'supervisions/(:id)/documents/(:document_id)',
          to: 'supervisions#document',
          as: 'supervision_document'

      # get 'supervisions/(:id)/activities',
      get 'supervisions/:orientation_id/calendars/:calendar_id/activities',
          to: 'supervision_activities#index',
          as: 'supervision_calendar_activities'

      # get 'supervisions/(:id)/activities/(:activity_id)',
      get 'supervisions/:orientation_id/calendars/:calendar_id/activities/:id',
          to: 'supervision_activities#show',
          as: 'supervision_calendar_activity'

      get 'supervisions/examination_boards',
          to: 'supervision_examination_boards#index',
          as: 'supervision_examination_boards'

      get 'supervisions/examination_boards/(:id)',
          to: 'supervision_examination_boards#show',
          as: 'supervision_examination_board'

      get 'calendars/:calendar_id/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      get 'calendars/:calendar_id/activities/:id',
          to: 'activities#show',
          as: 'calendar_activity'

      post 'examination_boards/(:id)/defense_minutes',
           to: 'examination_boards#defense_minutes',
           as: 'examination_board_defense_minutes'

      post 'examination_boards/(:id)/non_attendance_defense_minutes',
           to: 'examination_boards#non_attendance_defense_minutes',
           as: 'examination_board_non_attendance_defense_minutes'

      post 'examination_boards/(:id)/notes',
           to: 'examination_board_notes#create',
           as: 'examination_board_notes'

      patch 'examination_boards/(:id)/notes/(:note_id)',
            to: 'examination_board_notes#update',
            as: 'examination_board_note'

      post 'examination_boards/(:id)/files',
           to: 'examination_board_files#create',
           as: 'examination_board_files'

      patch 'examination_boards/(:id)/files/(:note_id)',
            to: 'examination_board_files#update',
            as: 'examination_board_file'

      get 'examination_boards/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#index',
          as: 'examination_boards_search'

      get 'orientations/history/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#history',
          as: 'orientations_search_history'

      get 'orientations/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#tcc_one',
          as: 'orientations_search_tcc_one'

      get 'orientations/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'orientations#tcc_two',
          as: 'orientations_search_tcc_two'

      get 'supervisions/history/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'supervisions#history',
          as: 'supervisions_search_history'

      get 'supervisions/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'supervisions#tcc_one',
          as: 'supervisions_search_tcc_one'

      get 'supervisions/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'supervisions#tcc_two',
          as: 'supervisions_search_tcc_two'
    end

    namespace :tcc_one_professors do
      root to: 'dashboard#index'

      resources :examination_boards,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      get 'examination_boards/tcc_one',
          to: 'examination_boards#tcc_one',
          as: 'examination_boards_tcc_one'

      get 'examination_boards/tcc_two',
          to: 'examination_boards#tcc_two',
          as: 'examination_boards_tcc_two'

      get 'calendars/tcc_one', to: 'calendars#tcc_one', as: 'calendars_tcc_one'

      get 'examination_boards/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#tcc_one',
          as: 'examination_boards_tcc_one_search'

      get 'examination_boards/tcc_two/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#tcc_two',
          as: 'examination_boards_tcc_two_search'

      get 'calendars/(:calendar_id)/orientations',
          to: 'orientations#by_calendar',
          as: 'calendar_orientations'

      get 'calendars/(:calendar_id)/orientations/(:id)',
          to: 'orientations#show',
          as: 'calendar_orientation'

      get 'calendars/(:calendar_id)/orientations/(:id)/documents',
          to: 'orientations#documents',
          as: 'calendar_orientation_documents'

      get 'calendars/(:calendar_id)/orientations/(:id)/documents/(:document_id)',
          to: 'orientations#document',
          as: 'calendar_orientation_document'

      get 'orientations/(:orientation_id)/calendars/(:calendar_id)/activities',
          to: 'orientation_activities#index',
          as: 'orientation_calendar_activities'

      get 'orientations/(:orientation_id)/calendars/(:calendar_id)/activities/(:id)',
          to: 'orientation_activities#show',
          as: 'orientation_calendar_activity'

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
          constraints: { term: %r{[^/]+} },
          to: 'orientations#by_calendar',
          as: 'calendar_orientations_search'

      get 'calendars/tcc_one/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'calendars#tcc_one',
          as: 'calendars_search_tcc_one'
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

      resources :tep_requests,
                except: :show,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :tso_requests,
                except: :show,
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :meetings,
                only: [:index, :show],
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      resources :examination_boards,
                only: [:index, :show],
                constraints: { id: /[0-9]+/ },
                concerns: :paginatable

      patch 'meetings/(:id)/update_viewed',
            to: 'meetings#update_viewed',
            as: 'meeting_update_viewed'

      post 'documents/(:id)/sign', to: 'documents#sign', as: 'document_sign'
      get 'documents/pending', to: 'documents#pending', as: 'documents_pending'
      get 'documents/signed', to: 'documents#signed', as: 'documents_signed'
      get 'documents/(:id)', to: 'documents#show', as: 'document'

      get 'calendars', to: 'calendars#index', as: 'calendars'

      get '/calendars/(:calendar_id)/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      post '/calendars/(:calendar_id)/activities/(:id)',
           to: 'activities#create',
           as: 'calendar_activity_files'

      patch '/calendars/(:calendar_id)/activities/(:id)',
            to: 'activities#update',
            as: 'calendar_activity_file'

      get '/calendars/(:calendar_id)/activities/(:id)',
          to: 'activities#show',
          as: 'calendar_activity'

      get '/calendars/(:calendar_id)/orientations/(:id)/documents',
          to: 'orientations#documents',
          as: 'calendar_orientation_documents'

      get '/calendars/(:calendar_id)/orientations/(:id)/documents/(:document_id)',
          to: 'orientations#document',
          as: 'calendar_orientation_document'

      get 'calendars/(:calendar_id)/orientations/(:id)/activities',
          to: 'orientation_activities#index',
          as: 'calendar_orientation_activities'

      get 'calendars/(:calendar_id)/orientations/(:id)/activities/(:activity_id)',
          to: 'orientation_activities#show',
          as: 'calendar_orientation_activity'

      get 'examination_boards/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#index',
          as: 'examination_boards_search'
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

      resources :examination_boards,
                only: [:index, :show],
                constraints: { id: /[0-9]+/ }

      post 'documents/(:id)/sign', to: 'documents#sign', as: 'document_sign'
      get 'documents/pending', to: 'documents#pending', as: 'documents_pending'
      get 'documents/signed', to: 'documents#signed', as: 'documents_signed'
      get 'documents/(:id)', to: 'documents#show', as: 'document'

      get 'calendars', to: 'calendars#index', as: 'calendars'

      get '/calendars/(:calendar_id)/activities',
          to: 'activities#index',
          as: 'calendar_activities'

      get '/calendars/(:calendar_id)/activities/(:id)',
          to: 'activities#show',
          as: 'calendar_activity'

      post 'examination_boards/(:id)/notes',
           to: 'examination_board_notes#create',
           as: 'examination_board_notes'

      patch 'examination_boards/(:id)/notes/(:note_id)',
            to: 'examination_board_notes#update',
            as: 'examination_board_note'

      post 'examination_boards/(:id)/files',
           to: 'examination_board_files#create',
           as: 'examination_board_files'

      patch 'examination_boards/(:id)/files/(:note_id)',
            to: 'examination_board_files#update',
            as: 'examination_board_file'

      get 'supervisions/history', to: 'supervisions#history', as: 'supervisions_history'

      get 'supervisions/(:id)/documents',
          to: 'supervisions#documents',
          as: 'supervision_documents'

      get 'supervisions/(:id)/documents/(:document_id)',
          to: 'supervisions#document',
          as: 'supervision_document'

      # get 'orientations/(:orientation_id)/calendars/(:calendar_id)/activities',
      # get 'supervisions/(:id)/activities',
      get 'supervisions/:supervision_id/calendars/:calendar_id/activities',
          to: 'supervision_activities#index',
          as: 'supervision_calendar_activities'

      get 'supervisions/:supervision_id/calendars/:calendar_id/activities/:id',
          # get 'supervisions/(:id)/activities/(:activity_id)',
          to: 'supervision_activities#show',
          as: 'supervision_calendar_activity'

      get 'supervisions/tcc_one',
          to: 'supervisions#tcc_one',
          as: 'supervisions_tcc_one'

      get 'supervisions/tcc_two',
          to: 'supervisions#tcc_two',
          as: 'supervisions_tcc_two'

      get 'supervisions/history/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'supervisions#history',
          as: 'supervisions_search_history'

      get 'supervisions/tcc_one/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'supervisions#tcc_one',
          as: 'supervisions_search_tcc_one'

      get 'supervisions/tcc_two/(:status)/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'supervisions#tcc_two',
          as: 'supervisions_search_tcc_two'

      get 'examination_boards/search/(:term)/(page/:page)',
          constraints: { term: %r{[^/]+} },
          to: 'examination_boards#index',
          as: 'examination_boards_search'
    end
  end

  #========================================
  # Site
  #========================================
  get 'calendario', to: 'site#calendar', as: 'site_calendar'
  get 'bancas-de-tcc', to: 'site#examination_boards', as: 'site_examination_boards'
  get 'professores', to: 'site#professors', as: 'site_professors'
  get 'professores/(:id)', to: 'site#professor', as: 'site_professor'
  get 'tccs-aprovados', to: 'site#approved_orientations', as: 'site_approved_orientations'
  get 'tccs-aprovados-em-tcc-um', to: 'site#approved_tcc_one_orientations',
                                  as: 'site_approved_tcc_one_orientations'
  get 'tccs-em-tcc-um', to: 'site#in_tcc_one_orientations', as: 'site_in_tcc_one_orientations'

  # post 'tccs-aprovados/ano/(:year)',
  #      to: 'site#approved_orientations_by_year',
  #      as: 'site_approved_orientations_by_year'

  # post 'tccs-em-andamento/ano/(:year)',
  #      to: 'site#in_progress_orientations_by_year',
  #      as: 'site_in_progress_orientations_by_year'

  get '(:page)', to: 'site#page', as: 'site_page'

  #========================================
  # API
  #========================================
  namespace 'api' do
    namespace 'v1' do
      get 'orientations/approved', to: 'orientations#approved', as: 'orientations_approved'
      get 'orientations/approved-tcc-one', to: 'orientations#approved_tcc_one',
                                           as: 'orientations_approved_tcc_one'
      get 'orientations/in-tcc-one', to: 'orientations#in_tcc_one', as: 'orientations_in_tcc_one'
    end
  end
end
