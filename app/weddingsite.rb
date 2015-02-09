require 'sinatra/base'
require 'sinatra/static_assets'

class WeddingSite < Sinatra::Base
  register Sinatra::StaticAssets

  get '/' do
    erb :index
  end

  get '/photos' do
    'Photo Galleries coming soon.'
  end

  get '/gifts' do
    'Here\'s what you should gift us :)'
  end


    get '/rsvp' do   
      erb :rsvp
    end
  
  private
  def get_image_url(image)
    "https://dl.dropboxusercontent.com/u/58780672/WeddingWebsite/site-images/#{image}"
  end
end
