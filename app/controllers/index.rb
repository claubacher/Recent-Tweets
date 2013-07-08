get '/' do
  erb :index
end

post '/' do
  @user = User.find_or_create_by_handle(params[:twitter_handle])
  puts "========================="
  puts @user.handle
  if @user.tweets_stale?
    @user.fetch_tweets!
  end  
  @tweets = @user.tweets.all
  erb :tweets, :layout => false
end
