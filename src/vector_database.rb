class VectorDatabase
  attr_reader :open_ai_api

  def initialize
    @open_ai_api = OpenAiApi.new
  end

  def load_content(klass, content, content_source, document = nil)
    embedding = open_ai_api.get_embedding_for(content)
    data = { content: content, embedding: embedding, content_source: content_source }
    data[:document] = document unless document.nil?
    klass.create!(data)
  end
end
