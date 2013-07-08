class User < ActiveRecord::Base
  has_many :tweets

  def fetch_tweets!
    self.tweets.all.each(&:destroy)
    timeline = Twitter.user_timeline(self.handle)
    timeline.each do |tweet|
      self.tweets.create(:text => tweet[:text],
                         :tweeted_at => tweet[:created_at])
    end 
  end

  def tweets_stale?
    return true if self.tweets.empty?

    times_between_tweets = []
    0.upto(self.tweets.length - 2) do |index|
      times_between_tweets << (self.tweets[index].tweeted_at - self.tweets[index + 1].tweeted_at)
    end
    avg = times_between_tweets.inject(:+)/times_between_tweets.length

    return (Time.now - self.tweets.first.created_at) > avg
  end
end


