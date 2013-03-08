VlineDemoApp::Application.routes.draw do
  mount Vline::API => '_vline/api'

  match '_vline/api/v1/oauth/authorize' => 'vline#authorize'

  match '_vline/launch' => 'vline#launch'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end