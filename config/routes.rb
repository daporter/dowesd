Dowesd::Application.routes.draw do
  get "static_pages/contact"

  resources :txns

  root :to => 'txns#index'
end
