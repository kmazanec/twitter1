get '/' do

  if session[:message]
    @message = session[:message]
  end

  erb :index
end

get '/:username' do

  @user = TwitterUser.find_by_screen_name(params[:username])

  if @user.nil? || @user.tweets.empty? || @user.tweets_stale?
    @user = TwitterUser.new(screen_name: params[:username])
    erb :index
  else
    @tweet_array = @user.tweets.limit(10).order("tweeted_at DESC")
    puts "Cache still smells good."
  end

  erb :user 
end


get '/ajax/:username' do

  @user = TwitterUser.find_by_screen_name(params[:username]) 

  unless @user
    tweet_array = Twitter.user_timeline(params[:username])
    @user = TwitterUser.create(screen_name: tweet_array.first[:attrs][:user][:screen_name],
                                name: tweet_array.first[:attrs][:user][:name],
                                location: tweet_array.first[:attrs][:user][:location],
                                description: tweet_array.first[:attrs][:user][:description],
                                twitter_id: tweet_array.first[:attrs][:user][:id])
  
  end

  tweet_array ||= Twitter.user_timeline(params[:username])

  puts "Tweets are stale!  Getting new tweets!"
  
  tweet_array.each do |tweet|
    @user.tweets << Tweet.find_or_create_by(tweet_id: tweet[:attrs][:id].to_i,
                                text: tweet[:attrs][:text], 
                                tweeted_at: tweet[:attrs][:created_at])
  end

  @tweet_array = @user.tweets.limit(10).order("tweeted_at DESC")
  @user.save

  erb :user, layout: false

end


post '/get_tweets' do

  redirect to "/#{params[:username]}"

end

post '/send_tweet' do
  sleep(0.5)
  if true#Twitter.update(params[:new_tweet])
    session[:message] = "Successfully tweeted!"
  else
    session[:message] = "Failed to send message"
  end

  if request.xhr?
    session[:message]
  else
    redirect to '/'
  end
end







