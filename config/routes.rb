Rails.application.routes.draw do

  scope module: 'public' do
    root to: "landing#index"
  end
end
