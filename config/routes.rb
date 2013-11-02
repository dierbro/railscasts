Railscasts::Application.routes.draw do
  root :to => "episodes#index"

  get "auth/:provider/callback", to: "users#create"
  get "about", to: "info#about", as: "about"
  get "give_back", to: "info#give_back", as: "give_back"
  get "moderators", to: "info#moderators", as: "moderators"
  get "login", to: "users#login", as: "login"
  get "logout", to:  "users#logout", as: "logout"
  get "feedback", to: "feedback_messages#new", as: "feedback"
  get "episodes/archive", to: redirect("/?view=list")
  get 'unsubscribe/:token', to: 'users#unsubscribe', as: "unsubscribe"
  post "versions/:id/revert", to: "versions#revert", as: "revert_version"

  get "episode_detailed/:id", to: "episodes#show"
  resources :users do
    member { put :ban }
  end
  resources :comments
  resources :episodes
  resources :feedback_messages

  get "tags/:id", to: redirect("/?tag_id=%{id}")
end
