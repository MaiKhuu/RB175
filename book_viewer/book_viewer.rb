require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

get "/" do
  @main_title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt") # this returns an array

  erb :home
end

get "/chapters/1" do
  @main_title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")
  @chapter_content= File.read("data/chp1.txt")
  @chapter_content.gsub!("\n\n", "<br><br>")

  erb :chapter
end
