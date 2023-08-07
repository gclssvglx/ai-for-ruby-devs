require "openai"

class OpenAiApi
  def ask_question(question)
    prompt = <<~CONTENT
      Answer the question based on the context below.
      If the question can't be answered based on the context, say \"I don't know\".
      Context: #{create_context(question)}
      Question: #{question}
    CONTENT

    get_answer_to_question(prompt)
  end

  def get_embedding_for(text)
    client.embeddings(
      parameters: {
        model: ENV["EMBEDDING_MODEL"],
        input: text
      }
    ).dig("data", 0, "embedding")
  end

  private

  def create_context(question)
    ContentItem.nearest_neighbors(
      :embedding,
      get_embedding_for(question),
      distance: ENV["EMBEDDING_DISTANCE"]
    ).first.content
  end

  def get_answer_to_question(prompt)
    client.chat(
      parameters: {
        model: ENV["CHAT_MODEL"],
        messages: [{ role: "user", content: prompt }],
        temperature: ENV["CHAT_TEMPERATURE"].to_f
      }
    ).dig("choices", 0, "message", "content")
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPEN_AI_ACCESS_TOKEN"])
  end
end
