Dowesd::Application.routes.draw do
  root :to => 'txns#index'

  match '/about',   :to => 'static_pages#about'
  match '/contact', :to => 'static_pages#contact'

  resources :txns
end
