Rails.application.routes.draw do
	resources :registrations
	resources :sessions
	resources :auth

	# Needs to be conabilized to work with api login
	# devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

	resources :members
	resources :comments
	resources :charities
	resources :featured_members
	resources :charity_featured_members
	resources :charges
	resources :sponsors
	resources :sponsorships
	post '/sessions/charities', to: 'sessions#create_charity'
	post '/registrations/charities', to: 'registrations#create_charity'
end
