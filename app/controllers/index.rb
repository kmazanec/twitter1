get '/' do

  erb :index
end

get '/:username' do
  @user = TwitterUser.find_by_screen_name(params[:username])
  unless @user
    tweet_array = Twitter.user_timeline(params[:username])
    @user = TwitterUser.create(screen_name: tweet_array.first[:attrs][:user][:screen_name],
                                name: tweet_array.first[:attrs][:user][:name],
                                location: tweet_array.first[:attrs][:user][:location],
                                description: tweet_array.first[:attrs][:user][:description],
                                twitter_id: tweet_array.first[:attrs][:user][:id])
  
  end
  
  if @user.tweets.empty? || @user.tweets_stale?
    tweet_array ||= Twitter.user_timeline(params[:username])

    puts "Tweets are stale!  Getting new tweets!"
    
    tweet_array.each do |tweet|
      @user.tweets << Tweet.find_or_create_by(tweet_id: tweet[:attrs][:id].to_i,
                                  text: tweet[:attrs][:text], 
                                  tweeted_at: tweet[:attrs][:created_at])
    end
    @user.save
  else
    puts "Cache still smells good."
  end

  @tweet_array = @user.tweets.limit(10).order("tweeted_at DESC")

  erb :index 
end
