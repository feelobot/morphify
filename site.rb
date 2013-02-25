require 'rubygems'
require 'sinatra'
require 'haml'
require 'cucumber'
require 'uri'
require 'redis'

#Define Song Directory
@song_dir = "public/songs/"

When /^I connect to redis$/ do
  #Create Redis Object
  @r = Redis.new
end

And /^I search for the top five chipmunked songs$/ do
  @top5 = @r.zrevrangebyscore("chipmunked","+inf","-inf",:with_scores => true, :limit => [0, 5])
end

Then /^I should get a valid output$/ do
  puts "Top 5 are: #{@top5}"
end

Then /^I should be able to output the songs artist and title$/ do
  @top5.each do |x|
    key = x[0]
    song = @r.hgetall("songs:#{key}")
    puts song
  end
end

#Download ~ YouTubs Video & Extract Audio
helpers do 
  def extract_audio
    @ytid=params[:url]
    `youtube-dl --extract-audio --audio-format=wav -k http://www.youtub.ecom/watch?v=#{@ytid}`
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

