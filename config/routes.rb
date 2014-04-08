Epoch::Application.routes.draw do

  resources :reports  # top 10 graph
  resources :links    # top 25 links

  post  'fetch',    to: 'fetch#create'
  root  "fetch#index"
end
