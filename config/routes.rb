Rails.application.routes.draw do
	resources :registrations
	resources :sessions
	resources :auth
	resources :members
	resources :comments
	resources :charities
	resources :featured_members
	resources :charity_featured_members
	resources :charges
<<<<<<< Updated upstream
=======
  resources :donations
	resources :sponsors
	resources :sponsorships
	post '/search', to: 'search#show'
>>>>>>> Stashed changes
	post '/sessions/charities', to: 'sessions#create_charity'
	post '/registrations/charities', to: 'registrations#create_charity'
end
