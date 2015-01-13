EbuOndemand::Application.routes.draw do
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

  resources :tags
  
  # Dynamic route to send files from public/media. Better done using a Apache
  # rewrite rule in production! This is only included here as a fallback.
  get('/media/*other', to: "media#serve", format: false) unless Rails.env.production?
  
  put  'codem_notifications'       => 'codem_notifications#create'
  post 'http_runner_notifications' => 'http_runner_notifications#create'
  
  get 'cron/job_state'
  get 'cron/purge'
  get 'cron/organizations'
end
