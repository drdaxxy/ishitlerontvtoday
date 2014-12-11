#!/usr/bin/env ruby
require './main.rb'
require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = IsHitlerOnTvToday.twitter_consumer_key
  config.consumer_secret     = IsHitlerOnTvToday.twitter_consumer_secret
  config.access_token        = IsHitlerOnTvToday.twitter_access_token
  config.access_token_secret = IsHitlerOnTvToday.twitter_access_token_secret
end

shows = Show.today.all(:relevant => true)

if(shows.empty?)
	client.update("No! --%s" % Time.now.strftime("%b %e, %Y"))
else
	client.update("Yes! %d show(s), more info: %s --%s" % [shows.count, "http://ishitlerontvtoday.com/" + Time.now.strftime("%F"), Time.now.strftime("%b %e, %Y")])
end