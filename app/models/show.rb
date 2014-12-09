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
	
	validates_presence_of :channel, :unless => lambda { |o| o.relevant? }
	validates_with_block { @starts_at < @ends_at }
	# no overlaps
	validates_with_block { count(:starts_at.lt => @ends_at, :ends_at.gt => @starts_at) == 0 }
	
	def self.today
		all(:starts_at.lt => (Date.today + 1).to_time, :ends_at.gt => (Date.today - 1).to_time)
	end
end