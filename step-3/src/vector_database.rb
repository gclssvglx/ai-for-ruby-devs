class VectorDatabase
  attr_reader :open_ai_api, :debug

  def initialize
    @open_ai_api = OpenAiApi.new
    @debug = false
  end

  def load(content)
    embedding = open_ai_api.get_embedding_for(content)
    puts embedding if debug
    ContentItem.create!(content: content, embedding: embedding)
  end
end
