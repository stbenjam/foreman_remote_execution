Rails.application.routes.draw do
  resources :job_templates, :except => [:show] do
    member do
      get 'clone_template'
      get 'lock'
      get 'unlock'
      post 'preview'
    end
    collection do
      get 'revision'
      get 'auto_complete_search'
      get 'auto_complete_job_name'
    end
  end

  resources :job_invocations, :only => [:new, :create, :show, :index] do
    collection do
      post 'refresh'
      get 'preview_hosts'
      get 'auto_complete_search'
    end
    member do
      get 'rerun'
    end
  end

  resources :template_invocations, :only => [:show]

  namespace :api, :defaults => {:format => 'json'} do
    scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'}, :apiv => /v1|v2/, :constraints => ApiConstraints.new(:version => 2, :default => true) do
      resources :job_invocations, :except => [:new, :edit, :update, :destroy]

      resources :job_templates, :except => [:new, :edit] do
        (resources :locations, :only => [:index, :show]) if SETTINGS[:locations_enabled]
        (resources :organizations, :only => [:index, :show]) if SETTINGS[:organizations_enabled]
        post :clone, :on => :member
        collection do
          get 'revision'
        end

        resources :template_inputs, :only => [:index, :show, :create, :new]
      end
    end
  end
end
