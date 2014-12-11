require 'bundler/setup'
require 'sinatra/base'
require 'data_mapper'
require 'erubis'
require 'date'
require './config.rb'

Dir[File.dirname(__FILE__) + "/app/routes/**"].each do |route|
	require route
end

Dir[File.dirname(__FILE__) + "/app/models/**"].each do |model|
	require model
end

class IsHitlerOnTvToday
	configure do
		set :views, 'app/views'
		set :threaded, true
		set :erb, :escape_html => true
	end
	
	configure :development do
		set :bind, '0.0.0.0'
		enable :logging
	end
	
	helpers do
		def br(str)
			str.gsub("\r\n", "<br>").gsub("\n", "<br>")
		end
		
		def h(str)
			Rack::Utils.escape_html(str)
		end
		
		def br_h(str)
			br(h(str))
		end
	end

	DataMapper::setup(:default, settings.database)

	DataMapper.finalize
	DataMapper.auto_upgrade!

	run! if __FILE__ == $0
end