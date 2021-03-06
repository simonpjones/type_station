TypeStation::Engine.routes.draw do
  root :to => 'pages#index'

  namespace :admin, path: "_admin" do
    resources :pages, only: [:index, :create, :update] do
      get :move, on: :member
    end
  end

  match "*path", to: "pages#show", via: :all
end
