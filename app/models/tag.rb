class Tag
	include DataMapper::Resource
	
	property :name, String, :key => true
end