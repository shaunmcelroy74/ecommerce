Rails.application.routes.draw do
  get "checkouts/new"
  get "checkouts/create"
  get "checkouts/show"
  devise_for :users
  # Admin namespace routes
  namespace :admin do
    resources :pages
    resources :orders
    resources :products
    resources :categories
  end

  # Devise routes for admin authentication
  devise_for :admins

  # Health check route – returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA (Progressive Web App) routes (uncomment if needed)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Define the root path
  root "home#index"

  # Authenticated admin root
  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end

  # Public routes for static pages
  get "/about", to: "pages#about", as: :about
  get "/contact", to: "pages#contact", as: :contact
  # You could alternatively have resources :pages, only: [:show] if needed.

  # Public (non-admin) routes for categories
  resources :categories, only: [ :show ]

  # Public (non-admin) routes for products:
  # Only the show action plus a custom search action.
  resources :products, only: [ :show ] do
    collection do
      get :search
    end
  end

  # Additional custom routes
  get "admin" => "admin#index"
  get "/cart", to: "carts#show", as: :cart
end
