Rails.application.routes.draw do
  resources :users
  get "create_fast", to: "users#create_fast"
  get "main", to: "users#login_page"
  post "main", to: "users#check_login"
  get "users/:user_id/posts/new", to: "users#create_post", as: "new_post"
  post "users/:user_id/posts/new", to: "users#add_post", as: "add_post"
  get "users/:user_id/posts/:post_id/edit", to: "users#edit_post_page", as: "edit_post"
  patch "users/:user_id/posts/:post_id/edit", to: "users#update_post", as: "update_post"
  delete "users/:user_id/posts/:post_id/delete", to: "users#delete_post_page", as: "delete_post"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
