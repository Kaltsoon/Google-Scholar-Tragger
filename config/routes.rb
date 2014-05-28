GoogleScholarTragger::Application.routes.draw do
  
  resources :users, only: [:show, :index, :create, :new, :destroy]

  resources :query_clicks, only: [:create]

  resources :scholar_queries, only: [:create, :destroy, :show, :index]


  get "/login", to: "users#admin_login"
  post "/download_user_data", to: "users#download_data"
  get "/", to: "users#admin_login"
  post "/login", to: "users#admin_login_check"
  post "/logout", to: "users#admin_logout"

  get "/search/:token", to: "api#user_search"
  post "/query", to: "api#scholar_query"
  
  post "/feedback", to: "scholar_queries#feedback"
  post "/download_query_data", to: "scholar_queries#download_data"

end
