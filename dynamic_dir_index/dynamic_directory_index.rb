require "sinatra"
require "sinatra/reloader"

set :public_folder, 'public'

get '/' do
  @files = Dir.glob("public/*").map do |file|
    File.basename(file)
  end

  if params[:sort] == "ascending"
    @files.sort!
  elsif params[:sort] == "descending"
    @files.sort!.reverse!
  end

  erb :home
end
