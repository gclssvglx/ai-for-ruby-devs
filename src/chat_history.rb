# frozen_string_literal: true

# Simple Key-Value store, where the key is the session-id and the value is
#   the chat history between the user and the AI, as an array of hashes.

require 'openai'

class ChatHistory
  HISTORY_LIMIT = 10

  def initialize
    @messages = {}
  end

  def truncated_message_history(session_id, token_limit)
    token_count = 0
    message_history(session_id).take_while do |message|
      token_count += OpenAI.rough_token_count(message[:content])
      token_count <= token_limit
    end.reverse
  end

  def add_user_message(session_id, content)
    message = { role: 'user', content: }
    add_message(session_id, message)
  end

  def add_assistant_message(session_id, content)
    message = { role: 'assistant', content: }
    add_message(session_id, message)
  end

  private

  attr_reader :messages

  def add_message(session_id, message)
    session_messages = message_history(session_id)
    return @messages[session_id] = [message] if session_messages.blank?

    dequeue(session_id) if session_messages.length == HISTORY_LIMIT
    enqueue(session_id, message)
  end

  def dequeue(session_id)
    @messages[session_id].pop
  end

  def enqueue(session_id, message)
    @messages[session_id].unshift(message)
  end

  def message_history(session_id)
    messages[session_id]
  end
end
