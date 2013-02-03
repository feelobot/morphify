MONGOHQ_URL=mongodb://user:pass@server.mongohq.com/db_name

require 'mongo'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'cucumber'
#require 'sass'


#Define Song Directory
@song_dir = "public/songs/"

### MODELS
=begin
class Audio
  include DataMapper::Resource
  property :id,         Integer, :serial=>true
  property :title,      String
  property :ytid,       String
  property :created_at, DateTime
  property :chip_count, Integer, :default=>0
  property :back_count, Integer, :default=>0

  validates_present :title,:ytid
end
=end
When /^I connect to mongohq$/ do
  def get_connection
    return @db_connection if @db_connection
    db = URI.parse(ENV['MONGOHQ_URL'])
    db_name = db.path.gsub(/^\//, '')
    @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
    @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
    @db_connection
  end
end

#Download YouTube Video & Extract Audio
helpers do 
  def extract_audio
    @ytid=params[:url]
    `youtube-dl --extract-audio --audio-format=wav -k http://www.youtube.com/watch?v=#{@ytid}`
  end
  def set_site_vars(site)
    @css = site
    @favicon = site 
    @header_image = ""
    @header_title
    @site_title = ""
    @slogan = ""
  end
end

#Load The Correct Layout
get '/' do
  if request.url == "http://backmasked.com" || request.url == "http://www.backmasked.com"
    haml :index, layout => :back
  else
    haml :index, layout => :chip
  end 
end

get '/:ytid' do
  @ytid=params[:ytid]
  haml :player
  #else
  #  @msg = 'Sorry we could not find the song you are looking for...try searching the song in the search bar above.'
  #  haml :invalid
  #end
end

post '/chipmunkify/' do
  extract_audio
  `sox #{@ytid}.wav public/songs/chipmunked/#{@ytid}.wav speed 1.65`
end

post '/backmaskify/' do
  extract_audio
  `sox #{@ytid}.wav public/songs/backmasked/#{@ytid}.wav reverse`
end

