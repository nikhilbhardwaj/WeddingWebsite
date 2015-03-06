require 'sinatra/base'
require 'sinatra/static_assets'
require 'rack-flash'
require 'sinatra/redirect_with_flash'
require 'koala'
require_relative 'rsvp'


class WeddingSite < Sinatra::Base
  # Load credentials from .env during development
  if settings.development?
    require 'dotenv'
    Dotenv.load
  end

  register Sinatra::StaticAssets
  use Rack::Session::Cookie, secret: ENV['FACEBOOK_SECRET']
  use Rack::Flash
  helpers Sinatra::RedirectWithFlash

  get '/' do
    erb :index
  end

  get '/rsvp' do
    # Prefetch RSVP if it is set
    if session['access_token']
      @profile = get_fb_profile
      @rsvp = Rsvp.get(@profile['id'])
      @friends = get_fb_friends
    end
    # Update ERB to prepopulate the values that had been filled in
    erb :rsvp
  end

  get '/photos' do
    'Photo Galleries coming soon.'
  end

  get '/gifts' do
    erb :gifts
  end

  get '/login' do
    # generate a new oauth object with your app data and your callback url
    session['oauth'] = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], "#{request.base_url}/callback")
    # redirect to facebook to get your code
    redirect session['oauth'].url_for_oauth_code()
  end

  get '/logout' do
    session.clear
    redirect '/', notice: 'Successfully Logged out'
  end

  #method to handle the redirect from facebook back to us
  get '/callback' do
    #get the access token from facebook with your code
    session['access_token'] = session['oauth'].get_access_token(params[:code])
    redirect '/rsvp', notice: 'Successfully Logged in with Facebook'
  end

  # Handle the Save and Discard Buttons on the RSVP page
  post '/rsvp' do
    ensure_valid_session
    if params[:action] == "save"
      profile = get_fb_profile
      # construct rsvp from form and id
      rsvp = Rsvp.get(profile['id']) || Rsvp.new
      rsvp.id = profile['id']
      rsvp.token = session['access_token']
      rsvp.attending = params[:attending_radios]
      rsvp.locations = params['locations_checkboxes']
      rsvp.comments = params[:textarea]
      rsvp.save
    end
    redirect '/rsvp' , notice: 'Your action was successful'
  end

  helpers do
    def ensure_valid_session
      halt 500 if !session['access_token']
    end
  end

  private
  def get_image_url(image)
    "https://dl.dropboxusercontent.com/u/58780672/WeddingWebsite/site-images/#{image}"
  end

  # Fetches the FB profile of the logged in user
  # This can be used for further meaningful queries
  def get_fb_profile
    graph = Koala::Facebook::API.new(session['access_token'])
    @profile = graph.get_object('me')
    @profile
  end

  def get_fb_friends
     graph = Koala::Facebook::API.new(session['access_token'])
     @friends = graph.get_connections('me','friends')
     @friends
  end
end
