class IsHitlerOnTvToday

	before '/admin/*' do
		unless session['secret'] == settings.secret
			redirect to('/adminlogin/')
		end
	end

	get '/adminlogin/' do
		"<form method='POST'><input type='password' name='secret'><input type='submit'></form>"
	end
	
	post '/adminlogin/' do
		session['secret'] = params[:secret]
		redirect to('/admin/')
	end
	
	get '/admin/' do
		@duplicate_dvbchannels = Dvbchannel.duplicates
	
		# don't want these to be lazily loaded
		@dvbchannels = Dvbchannel.all.reload
		
		@channels = Channel.all
		
		# we have to order them first
		all_shows = Show.all(:relevant => nil, :order => [:starts_at.asc])
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
	
	post '/admin/update_show' do
		show = Show.get(params[:id])
		if show.nil?
			halt "no show"
		end
		
		if params[:relevant] == "false"
			if show.update(:relevant => false)
				halt "success"
			else
				halt "error"
			end
			
		elsif params[:relevant] == "true"
			show.relevant = true
			show.channel = Channel.first(:name => params[:channel])
			params[:tags].split(",").each do |tag|
				show.tags << Tag.first_or_create(:name => tag.strip)
			end
			
			if show.save
				halt "success"
			else
				halt "error"
			end
			
		else
			halt "input error"
		end
	end
	
	post '/admin/create_channel' do
		if Channel.create(:name => params[:name])
			halt "success"
		else
			halt "error"
		end
	end

	post '/import/' do
		halt 403 unless request.cookies['secret'] == settings.secret
		request.body.rewind
		xmltv = Nokogiri::XML(request.body.read)

		xmltv.xpath("//channel").each do |channel|
			begin
				Dvbchannel.create(:dvbid => channel["id"], :name => channel.at_xpath("display-name").content)
			rescue
				# don't care about duplicate channel issues
			end
		end

		xmltv.xpath("//programme").each do |xml_show|
			begin
				show = Show.new(:channel_dvbid => xml_show["channel"],
					:starts_at => Time.parse(xml_show["start"]),
					:ends_at => Time.parse(xml_show["stop"]),
					:name => xml_show.at_xpath("title").content.to_s[0, 255])
				
				# description field is 2^16-1 characters max
				# tv_grab_epg doesn't seem to convert newlines to a sensible encoding
				show.description = xml_show.at_xpath("desc").content.to_s.gsub("\xC2\x8A", "\n")[0, 65535] unless xml_show.at_xpath("desc").nil?
				show.subtitle = xml_show.at_xpath("sub-title").content.to_s.gsub("\xC2\x8A", "\n")[0, 65535] unless xml_show.at_xpath("sub-title").nil?
				
				show.save
			rescue
				# again, don't care about validation errors
			end
		end
	end

end
