require 'mongo'
require 'rubygems'
require 'sinatra'
require 'haml'
require 'cucumber'
require 'uri'
#require 'sass'

#Define Song Directory
@song_dir = "public/songs/"

When /^I connect to mongohq$/ do
  def get_connection
    return @db_connection if @db_connection
    db = URI.parse(ENV['MONGOHQ_URL'])
    db_name = db.path.gsub(/^\//, '')
    @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
    @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
    @db_connection
  end
  @db = get_connection
end

When /^I grab all of the available collections$/ do
  puts "Collections"
  puts "==========="
  @collections = @db.collection_names
  puts @collections
end

When /^I search for the top five chipmunked songs$/ do
  @songs_selected= @collections[1]
  @coll = @db.collection(@songs_selected)
  @docs = @coll.find().limit(5)
end

Then /^I should get a valid json response$/ do
  puts "\nDocuments in #{@songs_selected}"
  puts "  #{@docs.count()} documents(s) found"
  puts "=========================="
  @docs.each{ |doc| puts doc.to_json }
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

