require "dotenv"
Dotenv.load("../.env")

require "openai"
require "sinatra"

get "/" do
  erb :index
end

post "/" do
  client = OpenAI::Client.new(access_token: ENV["OPEN_AI_ACCESS_TOKEN"])

  @reply = client.chat(
    parameters: {
      model: ENV["CHAT_MODEL"],
      messages: [{ role: "user", content: params[:prompt] }],
      temperature: ENV["CHAT_TEMPERATURE"].to_f
    }
  ).dig("choices", 0, "message", "content")

  erb :index
end
