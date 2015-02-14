require 'sinatra/base'
require 'sinatra/static_assets'
require 'koala'

class WeddingSite < Sinatra::Base
  # Load credentials from .env during development
  if settings.development?
    require 'dotenv'
    Dotenv.load
  end
  register Sinatra::StaticAssets
  use Rack::Session::Cookie, secret: ENV['FACEBOOK_SECRET']

  get '/' do
    erb :index
  end

  get '/rsvp' do
    erb :rsvp
  end

  get '/photos' do
    'Photo Galleries coming soon.'
  end

  get '/gifts' do
    'Here\'s what you should gift us :)'
  end

  get '/login' do
    # generate a new oauth object with your app data and your callback url
    session['oauth'] = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], "#{request.base_url}/callback")
    # redirect to facebook to get your code
    redirect session['oauth'].url_for_oauth_code()
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  #method to handle the redirect from facebook back to us
  get '/callback' do
    #get the access token from facebook with your code
    session['access_token'] = session['oauth'].get_access_token(params[:code])
    redirect '/'
  end

  private
  def get_image_url(image)
    "https://dl.dropboxusercontent.com/u/58780672/WeddingWebsite/site-images/#{image}"
  end
end
