class VectorDatabase
  attr_reader :open_ai_api

  def initialize
    @open_ai_api = OpenAiApi.new
  end

  def load(json)
    json.each do |item|
      page = item["page"]
      content = item["content"]

      embedding = open_ai_api.get_embedding_for(content)
      ContentItem.create!(page: page, content: content, embedding: embedding)

      sleep 20.seconds # Free API accounts are limited to 3 requests per minute
    end
  end
end
