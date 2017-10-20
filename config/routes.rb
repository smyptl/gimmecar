Rails.application.routes.draw do

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  scope module: :admin, constraints: { subdomain: /^admin(\.|$)/ } do
    get '/', to: 'login#index', as: :login
    post '/', to: 'login#create'

    get 'locations' => 'locations#index'

    scope ':slug', module: :location, as: :location do
      get '/dashboard', to: 'dashboard#index'
      get '/search', to: 'search#index'
      get '/vehicles', to: 'vehicles#index'

      get '/quotes', to: 'quotes#index'
      #post '/quotes', to: 'quotes#show'

      get  '/rates', to: 'rates#index'
      post '/rates', to: 'rates#update'

      get '/new', to: 'new#index'

      resources :rentals, except: [:new, :create] do
        get 'receipt/print', to: 'rentals/receipt#print'
        post 'receipt/email', to: 'rentals/receipt#email'

        get 'close', to: 'rentals/close#index'
        post 'close', to: 'rentals/close#create'

        get 'extend',  to: 'rentals/extend#index'
        post 'extend', to: 'rentals/extend#create'
      end

      get  'rentals/new'                                   => 'rentals/new#index'
      post 'rentals/new/rates'                             => 'rentals/new#rates'
      post 'rentals/new/validate-drivers'                  => 'rentals/new#validate_drivers'
      post 'rentals/new/vehicles'                          => 'rentals/new#vehicles'
      post 'rentals/new/validate-vehicles'                 => 'rentals/new#validate_vehicles'
      post 'rentals/new/validate-financial-responsibility' => 'rentals/new#validate_financial_responsibility'
      post 'rentals/new/validate-terms-and-conditions'     => 'rentals/new#validate_terms_and_conditions'
      post 'rentals/new'                                   => 'rentals/new#create'

      resources :reservations, except: [:new, :create] do
        post 'email-confirmation', to: 'email_confirmation#index'

        get 'verify-insurance',  to: 'verify_insurance#index'
        post 'verify-insurance', to: 'verify_insurance#create'
      end


      resources :drivers, only: [:show] do
        resources :insurance_policies
      end
      post 'drivers/search'

      resources :vehicles, only: [:index, :show] do
        get 'status', to: 'vehicles/status#index'
        post 'status', to: 'vehicles/status#create'
      end
    end
  end

  scope module: :public do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'

    get 'receipt', to: 'landing#r'
  end
end
