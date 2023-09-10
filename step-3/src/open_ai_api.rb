require "openai"

class OpenAiApi
  attr_reader :debug

  def initialize
    @debug = true
  end

  def ask_question(question)
    context = create_context(question)

    prompt = <<~CONTENT
      Answer the question based on the context below.
      If the question can't be answered based on the context, say \"The GDS Way has nothing to say on that matter.\".
      Context: #{context}
      Question: #{question}
    CONTENT

    puts "Prompt : #{prompt}" if debug

    get_answer_to_question(prompt)
  end

  def get_embedding_for(text)
    embeddings = client.embeddings(
      parameters: {
        model: ENV["EMBEDDING_MODEL"],
        input: text
      }
    )
    puts embeddings if debug
    embeddings.dig("data", 0, "embedding")
  end

  def create_context(question)
    neighbors = ContentItem.nearest_neighbors(
      :embedding,
      get_embedding_for(question),
      distance: ENV["EMBEDDING_DISTANCE"]
    )
    puts neighbors if debug
    neighbors.first(2).map(&:content)
  end

  def get_answer_to_question(prompt)
    answer = client.chat(
      parameters: {
        model: ENV["CHAT_MODEL"],
        messages: [{ role: "user", content: prompt }],
        temperature: ENV["CHAT_TEMPERATURE"].to_f
      }
    )
    puts answer if debug
    answer.dig("choices", 0, "message", "content") || answer.dig("error", "message")
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPEN_AI_ACCESS_TOKEN"])
  end
end
