Quora::Application.routes.draw do
  
  resources :wiki do
    collection do
      get :history
    end
    
    member do
      get :versions
      get :page_rollback
    end
  end
  
  resources :wiki

  # -- 用户登录认证相关 --
  root :to=>"index#index"
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
end
