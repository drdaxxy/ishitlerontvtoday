class IsHitlerOnTvToday

	get '/admin' do
		@shows = Show.in_text("Hitler") \
			+ Show.in_text("Nazi") \
			+ Show.in_text("Sozialis") \
			+ Show.in_text("Socialis") \
			+ Show.in_text("Nationalis") \
			+ Show.in_text("Rechtsextrem") \
			+ Show.in_text("Himmler") \
			+ Show.in_text("Goebbels") \
			+ Show.in_text("Weltkrieg") \
			+ Show.in_text("World War") \
			+ Show.in_text("Alliierte") \
			+ Show.in_text("Allied") \
			+ Show.in_text("Third Reich") \
			+ Show.in_text("Drittes Reich") \
			+ Show.in_text("Dritte Reich") \
			+ Show.in_text("Dritten Reich") \
			+ Show.in_text("NSDAP") \
			+ Show.in_text("NPD")
	end

end