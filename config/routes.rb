Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  resources :inboxes do
    member do
      post :edit
    end
  end

  root "inboxes#index"
end
