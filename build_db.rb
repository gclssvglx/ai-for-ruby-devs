require "dotenv"
Dotenv.load

require "active_record"
require "neighbor"
require "nokogiri"

require_relative "src/open_ai_api"
require_relative "src/document"
require_relative "src/chunk"
require_relative "src/vector_database"

def chunk_content(content)
  content.split("## ")
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
    t.timestamps
  end
end

vector_db = VectorDatabase.new

Dir.glob("gds-way/source/**/*.html.md.erb").each do |md_file|
  content = File.read(md_file)
  document = vector_db.load_document(content, "gds-way")

  chunks = chunk_content(content)
  chunks.each do |chunk|
    vector_db.load_chunk(chunk, document)
    # sleep 20.seconds
  end
end

Dir.glob("dev-docs/source/**/*.html.md.erb").each do |md_file|
  content = File.read(md_file)
  document = vector_db.load_document(content, "dev-docs")

  chunks = chunk_content(content)
  chunks.each do |chunk|
    vector_db.load_chunk(chunk, document)
    # sleep 20.seconds
  end
end
