# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

root to: 'home#index'

post '/directories/:id/images/sync', to: 'images#sync', as: 'sync', as: 'directorySyncImages'
get '/images/today-or-random', to: 'images#today-or-random', as: 'todayOrRandom'

# resources :images, only: [:index]
post '/directories/sync', to: 'directories#sync', as: 'directorySync'
delete '/directories/:id/remove', to: 'directories#remove', as: 'directoryRemove'
