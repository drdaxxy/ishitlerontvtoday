# encoding: utf-8
require './main.rb'
require 'uri'
require 'net/http'

import_uri = URI(IsHitlerOnTvToday.import_uri)
import_http = Net::HTTP.new(import_uri.host, import_uri.port)
import_req = Net::HTTP::Post.new(import_uri.path)
import_req["Cookie"] = "secret=#{IsHitlerOnTvToday.secret}"
import_req["Content-Type"] = "application/xml; charset=utf-8"


# This script expects to be executed in the main app's directory
# with r/w access
# and have access to w_scan, czap and tv_grab_dvb in PATH
# you should use a version of tv_grab_dvb that supports descriptions/subtitles
# such as https://github.com/nexgenta/tv_grab_dvb/tree/master
# obviously it needs permission to access your TV card
# I have not tested this with more than one TV card installed
# or other standards than DVB-C (you would have to adjust the commands)
# 
# Warning: Does not capture STDERR.

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
	xmltv_string = `/usr/local/bin/tv_grab_dvb`
	Process.kill("HUP", pid)

	import_req.body = xmltv_string
	import_http.request(import_req)
end
