require "dotenv"
Dotenv.load("../.env")

require "openai"

client = OpenAI::Client.new(access_token: ENV["OPEN_AI_ACCESS_TOKEN"])

question = nil
while question != "quit"
  print ("==> ")
  question = gets.chomp
  break if question == "quit"

  client.chat(
    parameters: {
      model: ENV["CHAT_MODEL"],
      messages: [{ role: "user", content: question }],
      temperature: ENV["CHAT_TEMPERATURE"].to_f,
      stream: proc do |chunk, _bytesize|
        print chunk.dig("choices", 0, "delta", "content")
      end
    }
  )
  print "\n"
end
