class Dvbchannel
	include DataMapper::Resource
	
	property :id, Serial
	property :dvbid, String, :required => true, :unique_index => :dvbid_name
	property :name, String, :required => true, :unique_index => :dvbid_name, :length => 255

	def self.duplicates
		dvbids = []
		aggregate(:dvbid, :all.count).each do |row|
			if row[1] > 1
				dvbids << row[0]
			end
		end
		return all(:dvbid => dvbids)
	end
	
	def to_s
		name
	end
end