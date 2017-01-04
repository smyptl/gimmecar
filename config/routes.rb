Rails.application.routes.draw do

  get "/404" => "errors#not_found"
  get "/422" => "errors#unacceptable"
  get "/500" => "errors#internal_error"

  scope module: 'admin', constraints: { subdomain: 'admin' } do
    root 'login#index'
  end

  scope module: 'public' do
    root 'landing#index'

    get  'reservation', to: 'reservation#index'
    post 'reservation', to: 'reservation#create'
  end
end
