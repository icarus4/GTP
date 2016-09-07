Rails.application.routes.draw do
  # devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  namespace :users do
    resources :sessions, only: [:new, :create]
    delete 'logout', to: 'sessions#destroy'
    get 'sign_up', to: 'registrations#new'
    resources :registrations, only: [:create]
  end

  # Company
  resources :companies, only: [:index]
  resources :partners, only: [:new, :index, :show]
  resources :suppliers, only: [:index, :new, :create]
  resources :customers, only: [:index, :new, :create]
  resources :item_series, only: [:new, :index, :show] do
    resources :items, shallow: true do
      post :upload_image, on: :member
      resources :variants, shallow: true
    end
  end

  resources :purchase_orders, only: [:index, :new, :create, :show] do
    put :approve, on: :member
    get :prepare_to_receive, on: :member
    post :receive, on: :member
  end

  resources :sales_orders, only: [:index, :new, :create, :show] do
    put :ship, on: :member
  end

  resources :stock_transfers, only: [:index, :new, :create, :show]

  scope :settings do
    resources :locations, only: [:index, :new, :create]
    resources :payment_terms, only: [:index]
    resources :payment_methods, only: [:index]
    resources :tax_types, only: [:index]
    resources :price_lists, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      resources :sales_orders, only: [:create] do
        get :next_number, on: :collection
      end
      resources :customers, only: [:index] do
        get :locations, on: :member
      end
      resources :locations, only: [:index, :update] do
        get :holds_stock, on: :collection
        resources :bin_locations, only: [:create]
      end
      resources :item_series, only: [:create] do
        resources :items, only: [:index, :create]
      end
      resources :brands, only: [:index, :create]
      resources :manufacturers, only: [:index, :create]
      resources :cities, only: [:index]
      resources :packaging_types, only: [:index]
      resources :partners, only: [:create] do
        resources :locations, only: [:index, :update], controller: 'partners/locations'
      end
      resources :payment_methods, only: [:index, :update, :create]
      resources :payment_terms, only: [:index, :update, :create]
      resources :tax_types, only: [:index, :update, :create]
      resources :price_lists, only: [:index, :update, :create]
    end
  end
end
