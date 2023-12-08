class VectorDatabase
  attr_reader :open_ai_api

  def initialize
    @open_ai_api = OpenAiApi.new
  end

  def load(content)
    embedding = open_ai_api.get_embedding_for(content)
    puts "Creating ContentItem : \n#{content}\n#{embedding}"
    ContentItem.create!(content: content, embedding: embedding)
  end
end
