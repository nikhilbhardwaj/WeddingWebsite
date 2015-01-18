require 'sinatra/base'

class WeddingSite < Sinatra::Base

  get '/' do
    erb :index
  end

  get '/photos' do
    'Photo Galleries coming soon.'
  end

  get '/gifts' do
    'Here\'s what you should gift us :)'
  end
end
