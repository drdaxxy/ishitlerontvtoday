class Show
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true, :length => 255
	property :subtitle, Text
	property :description, Text
	property :relevant, Boolean
	property :starts_at, DateTime, :required => true
	property :ends_at, DateTime, :required => true
	property :channel_dvbid, String, :required => true
	
	belongs_to :channel, :required => false
	
	has n, :tags, :through => Resource
	
	validates_presence_of :channel, :if => lambda { |o| o.relevant? }
	validates_with_block { @starts_at < @ends_at }
	
	# no overlaps, but allow updates of unchecked shows
	before :save do |show|
		Show.all(:starts_at.lt => show.ends_at, :ends_at.gt => show.starts_at, :channel_dvbid => show.channel_dvbid, :relevant => nil).destroy
	end
	
	def self.today
		all(:starts_at.lt => (Date.today + 1).to_time, :ends_at.gt => (Date.today).to_time - 1)
	end
end