Epoch::Application.routes.draw do
  get 'reports',  to: "reports#index"
  get 'redraw',   to: 'reports#redraw'  # helper route

  get 'links',    to: "links#index"
  get 'refresh',  to: 'links#refresh'   # helper route

  post  'fetch',  to: 'fetch#create'
  root  "fetch#index"
end
