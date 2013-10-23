Foodcartforest::Application.routes.draw do

  root      'entries#index'

  get "entries/manage" => "entries#manage", as: "manage_entries"
  resources :entries

  devise_scope :user do
    get    "/login" => "devise/sessions#new"
    get    "/signup" => "devise/registrations#new"
    delete "/logout" => "devise/sessions#destroy"
  end

  resources :comments, except: [:new, :show, :index]
  resources :entry_comments, except: [:new, :show, :index]

  resources :carts    

  devise_for :users
  resources :users, except: [:new]
end
