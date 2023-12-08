require "dotenv"
Dotenv.load

require "active_record"
require "neighbor"
require "sinatra"

require_relative "src/open_ai_api"
require_relative "src/content_item"

ActiveRecord::Base.establish_connection(
  adapter: ENV["DB_ADAPTER"],
  host: ENV["DB_HOST"],
  port: ENV["DB_PORT"],
  database: ENV["DB_NAME"],
)

open_ai_api = OpenAiApi.new

set :port, 3000

get "/" do
  erb :index
end

post "/" do
  @reply = open_ai_api.ask_question(params[:prompt])
  erb :index
end
