GoogleScholarTragger::Application.routes.draw do
  
  resources :tasks

  resources :users, only: [:show, :index, :create, :new, :destroy]

  resources :query_clicks, only: [:create]

  resources :scholar_queries, only: [:create, :destroy, :show, :index]

  post "/zip/:user_id", to: "users#download_zip"
 
  get "/login", to: "users#admin_login"
  post "/download_user_data", to: "users#download_data"
  get "/", to: "users#admin_login"
  post "/login", to: "users#admin_login_check"
  post "/logout", to: "users#admin_logout"

  get "/search/:token", to: "api#user_search"
  post "/query", to: "api#scholar_query"
  
  post "/feedback", to: "scholar_queries#feedback"
  get "/download_query_clicks/:query_id", to: "scholar_queries#download_clicks_timings"
  get "/download_query_scroll_behavior/:query_id", to: "scholar_queries#download_scroll_behavior"

  post "/query_scroll", to: "query_scrolls#create"

  post "/task_reports", to: "task_reports#create"
  post "/send_task_report", to: "task_reports#update"
  post "/download_task_report/:task_report_id", to: "task_reports#download_task_report"
  delete "/task_reports/:id", to: "task_reports#destroy"

  get "/users_tasks", to: "tasks#users_tasks"

  post "/query_click_end", to: "query_clicks#query_click_end"

end
