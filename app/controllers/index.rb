get '/' do
  erb :index
end

post '/' do
  @user = User.find_or_create_by_handle(params[:twitter_handle])
  if @user.tweets_stale?
    @user.fetch_tweets!
  end  
  @tweets = @user.tweets.all
  erb :tweets, :layout => false
end

get '/signin' do
  rt = request_token
  session[:request_token] = rt
  redirect rt.authorize_url
end


get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/oauth/callback' do
  rt = session[:request_token]
  @access_token = rt.get_access_token(:oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
  token = @access_token.token
  secret = @access_token.secret
  client = Twitter::Client.new(:oauth_token => token, :oauth_token_secret => secret)
  user = User.find_or_create_by_handle(:handle => client.user.screen_name, :token => token, :secret => secret)
  session[:request_token] = nil
  session[:user_id] = user.id
  redirect '/'
end


=begin

 - Use our TWITTER_KEY and TWITTER_SECRET to get the request token (include callback url when requesting token)
 - Store request token in session and redirect user to authorize URL using Oauth gem's "authorize_url" method
 - User returns to our site at the callback URL
 - Create an access token from the oauth_verifier, which is sent back as params from twitter.
 - The @access_token contains @token and @secret, which is stored in database for that user for future reference
 - A new client can be made using the token and secret: client = Twitter::Client.new(:oauth_token => token, :oauth_token_secret => secret)
 - Can then call all the twitter methods on the client: client.user_timeline

NOTE: with twitter, a callback url needs to be specified on the app settings page (any url)

QUESTION: Twitter returns the user with these params:
{"oauth_token"=>"ArgpHZHArJK9l9LKTPK0wEHFz1h2ljcMso4UxKJsdFA", "oauth_verifier"=>"9KYyHjkCxhKzVDeTWrbjQcf80IcHlabh91fCmYsBY"}

What is the oauth_token for?

QUESTION: Which token do we use to do Twitter stuff for the logged in user? Create a new client each time? Store client in session?

=end
