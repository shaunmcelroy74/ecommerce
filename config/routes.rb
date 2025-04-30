Rails.application.routes.draw do
  # ─── Payments (Stripe) ──────────────────────────────────────────────────────
  # POST   /payments          → payments#create
  # GET    /payments/success  → payments#success
  # GET    /payments/cancel   → payments#cancel
  resources :payments, only: [ :create ] do
    collection do
      get :success
      get :cancel
    end
  end

  # ─── Customer (public) side ───────────────────────────────────────────────
  devise_for :users

  resource  :cart,       only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]
  resources :checkouts,  only: [ :new, :create, :show ]

  get "/about",   to: "pages#about",   as: :about
  get "/contact", to: "pages#contact", as: :contact

  resources :categories, only: [ :show ]
  resources :products,   only: [ :show ] do
    collection { get :search }
  end

  # ─── Admin side ────────────────────────────────────────────────────────────
  devise_for :admins

  get "/admin", to: "admin#index", as: :admin
  namespace :admin do
    resources :pages
    resources :orders
    resources :products
    resources :categories
  end

  # ─── Miscellaneous ────────────────────────────────────────────────────────
  get "/up", to: "rails/health#show", as: :rails_health_check

  root "home#index"
  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end
end
