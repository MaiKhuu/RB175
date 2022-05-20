require 'sinatra'

class HiSinatra < Sinatra::Base
  get '/' do
    "hey sinatra!"
  end

  get "/asdfasdf" do
    "hello world"
  end

  get "/:age" do
    "Hi, I'm #{params[:age]} years old"
  end
end