Rails.application.routes.draw do

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  scope module: 'admin', constraints: { subdomain: 'admin' } do
    root 'login#index'
  end

  scope module: 'public' do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
