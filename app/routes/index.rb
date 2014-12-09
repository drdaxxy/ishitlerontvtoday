class IsHitlerOnTvToday
	get '/' do
		@shows = Show.today.all(:relevant => true)
		
		erb :index
	end
end