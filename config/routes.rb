# config/routes.rb
Rails.application.routes.draw do
  get "payments/success"
  get "payments/cancel"
  # ─── Customer (public) side ───────────────────────────────────────────────

  # Devise for customers
  devise_for :users

  # Shopping cart & checkout
  resource  :cart,       only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]
  resources :checkouts,  only: [ :new, :create, :show ]

  # Static content
  get "/about",   to: "pages#about",   as: :about
  get "/contact", to: "pages#contact", as: :contact

  # Browsing
  resources :categories, only: [ :show ]
  resources :products,   only: [ :show ] do
    collection { get :search }
  end

  # ─── Admin side ────────────────────────────────────────────────────────────

  # Devise for admins
  devise_for :admins

  # Dashboard entrypoint
  get "/admin", to: "admin#index", as: :admin

  # Namespaced CRUD for admin resources
  namespace :admin do
    resources :pages
    resources :orders
    resources :products
    resources :categories
  end

  # ─── Miscellaneous ────────────────────────────────────────────────────────

  # Health check (200 if booted properly)
  get "/up", to: "rails/health#show", as: :rails_health_check

  # Root paths
  root "home#index"
  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end
end
