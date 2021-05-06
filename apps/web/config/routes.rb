# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }

root to: 'home#index'

get '/about', to: 'home#about', as: 'about'

get '/images/today-or-random', to: 'images#today-or-random', as: 'todayOrRandom'

get '/directories', to: 'directories#index', as: 'directoryIndex'
post '/directories/sync', to: 'directories#sync', as: 'directorySync'
patch '/directories/:id', to: 'directories#update', as: 'directoryUpdate'
post '/directories/:id/images/sync', to: 'images#sync', as: 'directorySyncImages'
get '/images/subreddit', to: 'images#subreddit', as: 'subreddit'
