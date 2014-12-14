# encoding: utf-8
require './main.rb'
require 'nokogiri'

# This script expects to be executed in the main app's directory
# with r/w access
# and have access to w_scan, czap and tv_grab_dvb in PATH
# you should use a version of tv_grab_dvb that supports descriptions/subtitles
# such as https://github.com/nexgenta/tv_grab_dvb/tree/master
# obviously it needs permission to access your TV card
# I have not tested this with more than one TV card installed
# or other standards than DVB-C (you would have to adjust the commands)
# 
# Warning: Takes hours, especially against a remote database server. Does not capture STDERR.

system("w_scan -fc -c DE -X > channels.conf")
freqs = {}
File.read("channels.conf").lines.with_index(1) do |line, i|
	line = line.split(":")
	freqs[line[1]] = i
end

freqs.each_value do |channel_number|
	pid = Process.spawn("czap -c ./channels.conf -n #{channel_number}")
	# this script takes ages already, might as well...
	sleep 10
	xmltv_string = `tv_grab_dvb`
	Process.kill("HUP", pid)

	xmltv = Nokogiri::XML(xmltv_string)

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
