# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

root to: 'home#index'
get '/images/sync', to: 'images#sync'
get '/images/today-or-random', to: 'images#today-or-random', as: 'todayOrRandom'

resources :images, only: [:index]
