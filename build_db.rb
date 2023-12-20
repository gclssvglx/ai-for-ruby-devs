require "dotenv"
Dotenv.load

require "active_record"
require "neighbor"
require "nokogiri"

require_relative "src/open_ai_api"
require_relative "src/document"
require_relative "src/chunk"
require_relative "src/vector_database"

def load_content(content_source)
  vector_db = VectorDatabase.new

  Dir.glob("#{content_source}/source/**/*.html.md.erb").each do |md_file|
    content = File.read(md_file)
    document = vector_db.load_content(Document, content, content_source)

    # chunk by H2 tag
    content.split("## ").each do |chunk|
      vector_db.load_content(Chunk, chunk, content_source, document)
      # sleep 20.seconds
    end
  end
end

ActiveRecord::Base.establish_connection(
  adapter: ENV["DB_ADAPTER"],
  host: ENV["DB_HOST"],
  port: ENV["DB_PORT"],
  database: ENV["DB_NAME"],
)

ActiveRecord::Schema.define do
  enable_extension "vector"

  create_table :documents, force: true do |t|
    t.text :content
    t.vector :embedding, limit: 1536
    t.string :content_source
    t.timestamps
  end

  create_table :chunks, force: true do |t|
    t.integer :document_id
    t.text :content
    t.vector :embedding, limit: 1536
    t.string :content_source
    t.timestamps
  end
end

load_content("gds-way")
load_content("dev-docs")
