get '/' do
  erb :index
end

get '/:twitter_handle' do
  @user = User.find_or_create_by_handle(params[:twitter_handle])
  if @user.tweets_stale?
    @user.fetch_tweets!
  end  
  @tweets = @user.tweets.all
  erb :tweets
end
