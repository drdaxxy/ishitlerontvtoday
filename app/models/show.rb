class Show
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true, :length => 255
	property :subtitle, Text, :lazy => false
	property :description, Text, :lazy => false
	property :relevant, Boolean
	property :starts_at, DateTime, :required => true
	property :ends_at, DateTime, :required => true
	property :channel_dvbid, String, :required => true
	
	belongs_to :channel, :required => false
	
	has n, :tags, :through => Resource
	
	validates_presence_of :channel, :if => lambda { |o| o.relevant? }
	validates_with_block { @starts_at < @ends_at }
	
	# no overlaps, but allow updates of unchecked shows
	# ... if the update does not remove information
	# (Sky broadcasts minimal EPG information on all their channels)
	before :create do |show|
		overlaps = Show.all(:starts_at.lt => show.ends_at, :ends_at.gt => show.starts_at, :channel_dvbid => show.channel_dvbid, :relevant => nil)
		if not show.description.nil? and not show.subtitle.nil?
			overlaps.destroy
		else
			if not show.description.nil?
				overlaps.all(:description => nil).destroy
			elsif not show.subtitle.nil?
				overlaps.all(:subtitle => nil).destroy
			else
				overlaps.all(:description => nil, :subtitle => nil).destroy
			end
			# only save if no more overlaps in database
			throw :halt if overlaps.count > 0
		end
	end
	
	def self.on_day(day)
		all(:starts_at.lt => (day + 1).to_time, :ends_at.gt => day.to_time - 1)
	end
	
	def self.today
		on_day(Date.today)
	end
	
	def self.in_text(str)
		all(:description.like => "%#{str}%") + all(:subtitle.like => "%#{str}%") + all(:name.like => "%#{str}%")
	end
end