Rails.application.routes.draw do
  post 'login' => 'sessions#create'
  resources :users, only: [:create, :show, :index] do 
    resources :reports
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
