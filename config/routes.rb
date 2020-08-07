Rails.application.routes.draw do
  root :to => redirect("/feeds")

  resources :feeds
end
