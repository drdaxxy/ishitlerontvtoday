class IsHitlerOnTvToday
	get '/?:date?' do
		if params[:date].nil?
			@shows = Show.today.all(:relevant => true)
		else
			begin
				@date = Date.strptime(params[:date], "%F")
				throw ArgumentError if @date > Date.today
			rescue ArgumentError # invalid or future date
				redirect to("/")
			end
			@shows = Show.on_day(@date).all(:relevant => true)
		end
		
		erb :index
	end
end