class Channel
	include DataMapper::Resource

	property :id, Serial
	property :name, String, :required => true, :unique => true, :length => 255
end