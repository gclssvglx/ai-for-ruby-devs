class VectorDatabase
  attr_reader :open_ai_api

  def initialize
    @open_ai_api = OpenAiApi.new
  end

  def load_document(content, content_source)
    embedding = open_ai_api.get_embedding_for(content)
    Document.create!(
      content: content,
      embedding: embedding,
      content_source: content_source
    )
  end

  def load_chunk(content, document)
    embedding = open_ai_api.get_embedding_for(content)
    Chunk.create!(
      document: document,
      content: content,
      embedding: embedding
    )
  end
end
