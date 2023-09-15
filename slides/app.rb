require "sinatra"

set :port, 8080

get "/" do
  erb :index
end
