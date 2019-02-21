Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sites, only: [:index, :create, :destroy]


  get   '/items/', to: 'items#index'
  patch '/items/', to: 'items#update'
end
