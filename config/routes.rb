Rails.application.routes.draw do

  namespace :admin do
    constraints subdomain: 'admin' do
      get "/": "test#index"
    end
  end

  scope module: 'public' do
    root to: "landing#index"

    post "reservation/new": "reservation#new"
    post "reservation": "reservation#create"
  end
end
