Nomads::Application.routes.draw do
  post "/posts/update_location" => "posts#update_location"
  post "/suggestions/update_location" => "suggestions#update_location"
  post "/map/new_suggestion" => "map#new_suggestion"

  match "/cloudmailin" => "cloudmailin#index"
  match "/feeds/atom" => "feeds#atom", :as => :atom

  resources :suggestions do
    resources :comments
  end

  resources :posts do 
    resources :comments
  end
  resources :comments
  resources :users
  resources :icons
  
  match "/openid" => "openid#index"
  match "/openid/new", :as => :signin
  match "/openid/create" => "openid#create"
  match "/openid/complete" => "openid#complete"
  match "/openid/details" => "openid#details", :as => :details
  match "/openid/destroy" => "openid#destroy", :as => :signout

  match "/map" => "map#index", :as => :map
  match "/about" => "home#about", :as => :about
  match "/photos" => "flickr#index", :as => :photos
  match "/activity" => "activity#index", :as => :activity
  match "/activity/plain" => "activity#plain",  :collection => { :plain => :get }

  match "/home" => "home#index"
  match "/home/index" => "home#index"
  root :to => "home#index"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
