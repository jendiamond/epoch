Epoch::Application.routes.draw do

  resources :reports  # top 10 graph


  get 'links',   to: "links#index"
  get 'refresh', to: 'links#refresh'   # helper route

  post  'fetch',    to: 'fetch#create'
  root  "fetch#index"
end
