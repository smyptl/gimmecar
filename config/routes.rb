Rails.application.routes.draw do

  scope module: 'public' do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
