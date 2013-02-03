require 'rubygems'
require 'sinatra'
require 'haml'
#require 'sass'
require 'dm-core'

=begin

## DATABASE CONFIGURATION
configure :development do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => 'k1zkazkontrol',
    :database => 'morphify_dev'})  

  DataMapper::Logger.new(STDOUT, :debug)
end


configure :production do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'user' ,
    :password => 'pass',
    :database => 'sinatra_production'})  
end

#Define Song Directory
@song_dir = "public/songs/"

### MODELS
class Audio
  include DataMapper::Resource
  property :id,         Integer, Serial
  property :title,      String
  property :ytid,       String
  property :created_at, DateTime
  property :chip_count, Integer, :default=>0
  property :back_count, Integer, :default=>0

  validates_present :title,:ytid
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
=end

#Load The Correct Layout
get '/' do
  haml :index
end

get '/:ytid' do
  @ytid=params[:ytid]
  haml :player
  #else
  #  @msg = 'Sorry we could not find the song you are looking for...try searching the song in the search bar above.'
  #  haml :invalid
  #end
end

post '/convert/' do
    @ytid=params[:url]
    `youtube-dl --extract-audio --audio-format=wav -k http://www.youtube.com/watch?v=#{@ytid} && sox #{@ytid}.wav public/songs/backmasked/#{@ytid}.wav reverse`
end

