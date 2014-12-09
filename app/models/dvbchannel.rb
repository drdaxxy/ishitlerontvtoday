class Dvbchannel
	include DataMapper::Resource
	
	property :id, Serial
	property :dvbid, String, :required => true, :unique_index => :dvbid_name
	property :name, String, :required => true, :unique_index => :dvbid_name

	def self.duplicates
		dvbids = []
		aggregate(:dvbid, :all.count).each do |row|
			if row[1] > 1
				dvbids << row[0]
			end
		end
		return all(:dvbid => dvbids)
	end
end