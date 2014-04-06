Epoch::Application.routes.draw do
  resources :reports, only: [:index, :edit, :destroy]

  post 'fetch', to: 'fetch#create'
  root "fetch#index"
end
