Rails.application.routes.draw do

  scope module: 'admin', constraints: { subdomain: 'admin' } do
    root 'login#index'
  end

  scope module: 'public', constraints: { subdomain: '' } do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
