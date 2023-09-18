require "sinatra"

set :port, 3001

get "/" do
  erb :index
end
