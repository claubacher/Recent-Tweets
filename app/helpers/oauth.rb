
def request_token
  @callback_url = "http://127.0.0.1:9393/oauth/callback"
  @consumer = OAuth::Consumer.new(ENV['TWITTER_KEY'],ENV['TWITTER_SECRET'], :site => "https://api.twitter.com")
  @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
  # redirect @request_token.authorize_url

end

# access_token = prepare_access_token(Twitter.oauth_token, Twitter.oauth_token_secret)

# response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json")

