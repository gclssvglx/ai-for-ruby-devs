require "dotenv/load"
require "active_record"
require "neighbor"

require_relative "src/open_ai_api"
require_relative "src/content_item"

ActiveRecord::Base.establish_connection(
  adapter: ENV["DB_ADAPTER"],
  host: ENV["DB_HOST"],
  port: ENV["DB_PORT"],
  database: ENV["DB_NAME"],
)

open_ai_api = OpenAiApi.new

question = nil
while question != "quit"
  print ("==> ")
  question = gets.chomp
  break if question == "quit"
  puts open_ai_api.ask_question(question)
end
