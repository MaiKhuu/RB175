require "yaml"

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

helpers do
  def count_interests
    result = 0
    @data.values.each do |user|
      result += user[:interests].size
    end
    result
  end
end

before do
  @data = YAML.load_file("users.yaml")
  @users = @data.keys
end

get "/" do
  erb :home
end

not_found do
  redirect "/"
end

get "/users/:name" do
  @user_name = params[:name].to_sym
  redirect "/" if !@users.include?(@user_name)

  @user_email = @data[@user_name][:email]
  @user_interests = @data[@user_name][:interests]

  erb :user
end