Rails.application.routes.draw do

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  scope module: :admin, constraints: { subdomain: /^admin(\.|$)/ } do
    root 'login#index'
    post '/', to: 'login#create'

    get 'locations' => 'locations#index'

    scope ':slug', module: :location, as: :location do
      get '/dashboard', to: 'dashboard#index'
      get '/search', to: 'search#index'
      get '/vehicles', to: 'vehicles#index'

      get '/quotes', to: 'quotes#index'
      #post '/quotes', to: 'quotes#show'

      resources :rates

      get '/new', to: 'new#index'

      resources :reservations do
        post 'email-confirmation', to: 'email_confirmation#index'

        get 'verify-insurance',  to: 'verify_insurance#index'
        post 'verify-insurance', to: 'verify_insurance#create'
      end

      resources :rentals, except: [:new, :create] do
        post 'email-receipt', to: 'email_receipt#index'

        get 'extend',  to: 'extend#index'
        post 'extend', to: 'extend#create'
      end

      get  'rentals/new'                          => 'rentals/new#index'
      post 'rentals/new/rates'                    => 'rentals/new#rates'
      post 'rentals/new/drivers'                  => 'rentals/new#drivers'
      post 'rentals/new/vehicles'                 => 'rentals/new#vehicles'
      post 'rentals/new/add-ons'                  => 'rentals/new#add_ons'
      post 'rentals/new/financial-responsibility' => 'rentals/new#financial_responsibility'
      post 'rentals/new/terms-and-conditions'     => 'rentals/new#terms_and_conditions'
      post 'rentals/new'                          => 'rentals/new#create'

      resources :drivers, only: [:show] do
        resources :insurance_policies
      end
      post 'drivers/search'
    end
  end

  scope module: :public do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'

    get 'receipt', to: 'landing#r'
  end
end
