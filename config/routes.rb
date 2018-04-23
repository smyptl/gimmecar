Rails.application.routes.draw do

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  scope module: :admin, as: :admin, constraints: { subdomain: /^admin(\.|$)/ } do
    get '/', to: 'login#index', as: :login
    post '/', to: 'login#create'

    get 'locations' => 'locations#index'

    scope ':slug', module: :location, as: :location do
      get '/dashboard', to: 'dashboard#index'
      get '/search', to: 'search#index'
      get '/vehicles', to: 'vehicles#index'

      get  '/quote', to: 'quote#index'
      post '/quote', to: 'quote#create'

      get '/new', to: 'new#index'

      resources :rentals, except: [:new, :create] do
        get 'print', to: 'rentals/invoice#print'

        get 'close', to: 'rentals/close#index'
        post 'close', to: 'rentals/close#create'

        get 'extend',  to: 'rentals/extend#index'
        post 'extend', to: 'rentals/extend#create'
      end

      get  'rentals/new'                                   => 'rentals/new#index'
      post 'rentals/new/rates'                             => 'rentals/new#rates'
      post 'rentals/new/validate-drivers'                  => 'rentals/new#validate_drivers'
      post 'rentals/new/driver-search'                     => 'rentals/new#driver_search'
      post 'rentals/new/vehicles'                          => 'rentals/new#vehicles'
      post 'rentals/new/validate-vehicle'                  => 'rentals/new#validate_vehicle'
      post 'rentals/new/validate-financial-responsibility' => 'rentals/new#validate_financial_responsibility'
      post 'rentals/new/validate-terms-and-conditions'     => 'rentals/new#validate_terms_and_conditions'
      post 'rentals/new/driver-payment'                    => 'rentals/new#driver_payment'
      post 'rentals/new'                                   => 'rentals/new#create'

      resources :reservations, except: [:new, :create] do
        post 'email-confirmation', to: 'email_confirmation#index'

        get 'verify-insurance',  to: 'verify_insurance#index'
        post 'verify-insurance', to: 'verify_insurance#create'
      end

      resources :vehicles, only: [:index, :show] do
        get 'status', to: 'vehicles/status#index'
        post 'status', to: 'vehicles/status#create'
      end
    end
  end

  scope module: :command, as: :command, constraints: { subdomain: /^command(\.|$)/ } do
    get '/', to: 'login#index', as: :login
    post '/', to: 'login#create'

    get '/dashboard', to: 'dashboard#index'

    resources :rentals,  only: [:index, :show] do
      get 'extend', to: 'rentals/extend#index'
      post 'extend', to: 'rentals/extend#create'

      get 'return-deposit', to: 'rentals/return_deposit#index'
      post 'return-deposit', to: 'rentals/return_deposit#create'

      get 'print', to: 'rentals/invoice#index'
    end

    resources :vehicles, only: [:index, :show] do
      get 'add_registration', to: 'vehicles/add_registration#index'
      post 'add_registration', to: 'vehicles/add_registration#create'

      get 'rentals', to: 'vehicles/rentals#index'
      get 'revenue', to: 'vehicles/revenue#index'
    end

    resources :drivers,  only: [:index, :show] do
      get 'insurance-policies', to: 'drivers/insurance_policies#index'
      get 'rentals',            to: 'drivers/rentals#index'
      get 'metrics',            to: 'drivers/metrics#index'
      get 'sources',            to: 'drivers/sources#index'

      post 'add-card',          to: 'drivers/add_card#create'
    end

    resources :locations, only: [:index, :show] do
      get 'vehicles', to: 'locations/vehicles#index'
      get 'rentals',  to: 'locations/rentals#index'
      get 'revenue',  to: 'locations/revenue#index'
      get 'metrics',  to: 'locations/metrics#index'
    end

    get '/reports',     to: 'reports#index'
    get '/reports/tax', to: 'reports#tax'

    get '/quote',   to: 'quote#index'
    post  '/quote', to: 'quote#create'
  end

  scope module: :public do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
