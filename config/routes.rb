Rails.application.routes.draw do
  root to: 'front#redirect'
  post 'login' => 'sessions#create'
  resources :users do 
    resources :reports
  end
  get '*path', to: 'front#redirect'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
