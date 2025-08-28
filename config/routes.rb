Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "posts#index"
  namespace :internal do
    namespace :v1 do
      resources :invoices, only: :index
    end
  end
end
