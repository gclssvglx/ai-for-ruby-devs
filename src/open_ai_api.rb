# frozen_string_literal: true

require "openai"

class OpenAiApi
  OPEN_AI_TOKEN_LIMIT = 4096
  SYSTEM_MESSAGE = <<~CONTENT
    Answer the current Question: based on the latest Context:
    Take into account the the previous message history.
    If the question can't be answered based on the context, say \"I dunno!\".
  CONTENT

  def initialize(session_id, chat_history)
    @session_id = session_id
    @chat_history = chat_history
  end

  def ask_question(question)
    context = create_context(Document, question)
    # context = create_context(Chunk, question)

    prompt = "Context: #{context} Question: #{question}"
    chat_history.add_user_message(session_id, prompt)

    answer = get_answer_to_question
    chat_history.add_assistant_message(session_id, answer)

    answer
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

  attr_reader :chat_history, :session_id

  def create_context(klass, question)
    klass.nearest_neighbors(
      :embedding,
      get_embedding_for(question),
      distance: ENV["EMBEDDING_DISTANCE"]
    ).first(1).map(&:content)
  end

  def get_answer_to_question
    answer = client.chat(
      parameters: {
        model: ENV["CHAT_MODEL"],
        messages: [
          { role: 'system', content: SYSTEM_MESSAGE },
          *message_history
        ],
        temperature: ENV["CHAT_TEMPERATURE"].to_f
      }
    )
    answer.dig("choices", 0, "message", "content") || answer.dig("error", "message")
  end

  def message_history
    chat_history.truncated_message_history(session_id, token_limit)
  end

  def token_limit
    OPEN_AI_TOKEN_LIMIT - OpenAI.rough_token_count(SYSTEM_MESSAGE)
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPEN_AI_ACCESS_TOKEN"])
  end
end
