class IsHitlerOnTvToday

	get '/admin/' do
		# don't want these to be lazily loaded
		@dvbchannels = Dvbchannel.all.reload
		
		# we have to order them first
		all_shows = Show.all(:order => [:starts_at.asc])
		@shows = all_shows.in_text("Hitler") \
			+ all_shows.in_text("Nazi") \
			+ all_shows.in_text("Sozialis") \
			+ all_shows.in_text("Socialis") \
			+ all_shows.in_text("Nationalis") \
			+ all_shows.in_text("Rechtsextrem") \
			+ all_shows.in_text("Himmler") \
			+ all_shows.in_text("Goebbels") \
			+ all_shows.in_text("Weltkrieg") \
			+ all_shows.in_text("World War") \
			+ all_shows.in_text("Alliierte") \
			+ all_shows.in_text("Allied") \
			+ all_shows.in_text("Third Reich") \
			+ all_shows.in_text("Drittes Reich") \
			+ all_shows.in_text("Dritte Reich") \
			+ all_shows.in_text("Dritten Reich") \
			+ all_shows.in_text("NSDAP") \
			+ all_shows.in_text("NPD")
		
		erb :admin
	end

end