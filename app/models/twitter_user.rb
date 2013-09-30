class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets


  def tweets_stale?

    recent_tweets = self.tweets.limit(10).order("tweeted_at DESC")

    diff = recent_tweets.first.tweeted_at - recent_tweets.last.tweeted_at

    self.tweets.last.created_at < (Time.now - (diff/100))
  end

end
