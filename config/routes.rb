Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get "/users/finish_signup" => "users/omniauth_callbacks#finish_signup"
    post "/users/finished_signup" => "users/omniauth_callbacks#finished_signup"
  end

  scope defaults: { format: :json }, path: "/api" do
    resources :maps, only: [:index]
  end

  # For details on the DSL available within this file, see
  # http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
end

Rails.application.routes.draw do
  get "/pages/:page" => "pages#show"
end
