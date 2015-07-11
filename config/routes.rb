Rails.application.routes.draw do
  get 'users/new'

  # Maps a get request to  / to the "home" action in the StaticPages
  # Controller (file: /app/controllers/static_pages_controller.rb)
  root 'static_pages#home'

  # Maps a get request to  /help to the "help" action in the
  # StaticPages Controller (file: /app/controllers/static_pages_controller.rb)
  get 'help' => 'static_pages#help'

  get 'about' => 'static_pages#about'

  get 'contact' => 'static_pages#contact'

  get 'signup' => 'users#new'

  # Ressources Method adds all actions and routes needed for RESTful Users
  # ressurce:
  # HTTP-Request        Action    Route           Purpuse
  # ---------------------------------------------------------------------------
  # GET /users          index     users_path      page to list all users
  # GET /users/id       show      user_path(user) page to show a user
  # Get /users/new      new       new_user_path   page to make a new user (=signup)
  # POST /users         create    users_path      create a new user
  # GET  /users/id/edit edit      edit_user_path(user)  edit user with id=x
  # PATCH /users/id     update    user_path(user) update user
  # DELETE /users/id    destroy   user_path(user) delete user
  resources :users




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
