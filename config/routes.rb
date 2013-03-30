Cars::Application.routes.draw do

  root to: 'welcome#index'

  get 'admin' => 'cars#index', as: 'admin'
  get 'cars' => 'cars#index', as: 'cars'

  get 'about_us' => 'welcome#about_us', as: 'about_us'
  get 'contacts' => 'welcome#contacts', as: 'contacts'
  get 'partners' => 'welcome#partners', as: 'partners'
  get 'to_partners' => 'welcome#to_partners', as: 'to_partners'
  get 'rental_conditions' => 'welcome#rental_conditions', as: 'rental_conditions'

  get 'to_russian' => 'application#to_russian', as: 'to_russian'
  get 'to_english' => 'application#to_english', as: 'to_english'

  resources :cars, :except => [ :index ] do
    resource :rent, except: [ :show, :index ]
    resource :special_rent, except: [ :show, :index ]
    resource :driving_service, except: [ :show, :index ]
  end
  #get 'rent_requests/new' => 'rent_requests#new', as: 'new_rent_request'
  #get 'rent_requests/:id' => 'rent_requests#show', as: 'rent_request'

  resources :ads
  resources :global_notifications do
    put :activate, on: :member
  end

  resources :rent_requests, except: [ :edit ] do
    get 'confirm', on: :member
  end

  get 'rents' => 'rents#index', as: 'rents'
  get 'special_rents' => 'special_rents#index', as: 'special_rents'
  get 'driving_services' => 'driving_services#index', as: 'driving_services'

end
