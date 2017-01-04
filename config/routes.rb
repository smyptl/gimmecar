Rails.application.routes.draw do

  scope module: 'admin', constraints: { subdomain: 'admin' } do
    root 'login#index'
  end

<<<<<<< HEAD
  scope module: 'public', constraints: { subdomain: '' } do
=======
  scope module: 'public' do
>>>>>>> master
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
