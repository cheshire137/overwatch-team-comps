Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' },
    skip: [:sessions]

  devise_scope :user do
    get "/users/finish_signup" => "users/omniauth_callbacks#finish_signup"
    post "/users/finished_signup" => "users/omniauth_callbacks#finished_signup"
  end

  scope defaults: { format: :json }, path: "/api" do
    get "/composition/last" => "compositions#last_composition", as: :last_composition
    get "/composition/:slug" => "compositions#show", as: :composition
    post "/compositions" => "compositions#save", as: :compositions

    resources :players, only: [:create, :update, :destroy]

    resources :maps, only: [:index]

    get "/heroes/pool" => "heroes#pool", as: :hero_pool
    post "/heroes/pool" => "heroes#save"

    get "/user" => "users#current", as: :current_user
  end

  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  get "/pages/:page" => "pages#show", as: :page

  # Catch-all route so React can handle routing
  get '*path' => 'home#index'
end
