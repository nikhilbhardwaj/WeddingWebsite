require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/weddingsitedb')
DataMapper::Property::String.length(255)

class Rsvp
  include DataMapper::Resource
  property :id, Integer, key: true
  property :token, String
  property :attending, Integer
  property :locations, CommaSeparatedList
  property :comments, Text
end

DataMapper.finalize.auto_upgrade!
