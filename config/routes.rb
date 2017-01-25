Rails.application.routes.draw do

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  scope module: :admin, constraints: { subdomain: 'admin' } do
    root 'token#index'
    post '/', to: 'token#create'

    get 'locations' => 'locations#index'

    scope ':slug', module: :location, as: :location do
      get '/dashboard', to: 'dashboard#index'
      get '/search', to: 'search#index'
      get '/vehicles', to: 'vehicles#index'
      get '/quotes', to: 'quotes#index'

      resources :rates

      resources :reservations do
        post 'email-confirmation', to: 'email_confirmation#index'

        get 'verify-insurance',  to: 'verify_insurance#index'
        post 'verify-insurance', to: 'verify_insurance#create'
      end

      resources :rentals, except: [:edit, :update] do
        post 'email-receipt', to: 'email_receipt#index'

        get 'extend',  to: 'extend#index'
        post 'extend', to: 'extend#create'
      end

      get 'rentals/new/validate-drivers'
      get 'rentals/new/add-ons'
      get 'rentals/new/summary'
      get 'rentals/new/payment'

      resources :drivers, only: [:show] do
        resources :insurance_policies
      end
    end
  end

  scope module: :public do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
