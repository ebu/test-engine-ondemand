EbuOndemand::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Basic application endpoints
  scope Rails.application.config.ebu_plugit_local_root do
    get '/ping', to: "basic#ping"
    get '/version', to: "basic#version"

    root 'dashboard#index'

    resources :encoding_jobs do
      member do
        get 'status'
        get 'play'
        put 'reference_presets'
        put 'unreference_presets'
        put 'reference'
        put 'unreference'
        put 'reference_source_files'
        put 'unreference_source_files'
      end
    end

    resources :file_assets
    resources :preset_templates
    resources :organizations do
      collection do
        put 'update_multiple'
      end
    end
    
    resources :transcoders do
      member do
        get 'available'
      end
    end
    
    # Dynamic route to send files from public/media. Better done using a Apache
    # rewrite rule in production! This is only included here as a fallback.
    get '/media/*other', to: "media#serve", format: false
  end
  
  put  'codem_notifications'       => 'codem_notifications#create'
  post 'http_runner_notifications' => 'http_runner_notifications#create'
  
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
