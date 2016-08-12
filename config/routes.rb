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
  end

  namespace :api do
    namespace :v1 do
      resources :sales_orders, only: [:create] do
        get :next_number, on: :collection
      end
      resources :customers, only: [:index] do
        get :locations, on: :member
      end
      resources :locations, only: [:index]
      resources :item_series, only: [:create]
      resources :items, only: [:index, :create]
      resources :brands, only: [:index, :create]
      resources :manufacturers, only: [:index, :create]
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin' if Rails.env.development?

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
