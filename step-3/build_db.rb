require "dotenv"
Dotenv.load("../.env")

require "active_record"
require "neighbor"
require "nokogiri"

require_relative "src/open_ai_api"
require_relative "src/content_item"
require_relative "src/vector_database"

ActiveRecord::Base.establish_connection(
  adapter: ENV["DB_ADAPTER"],
  host: ENV["DB_HOST"],
  port: ENV["DB_PORT"],
  database: ENV["DB_NAME"],
)

ActiveRecord::Schema.define do
  enable_extension "vector"

  create_table :content_items, force: true do |t|
    t.text :content
    t.vector :embedding, limit: 1536

    t.timestamps
  end
end

vector_db = VectorDatabase.new
md_files = Dir.glob("gds-way/source/**/*.html.md.erb")
puts "Loading #{md_files.count} files..."

md_files.each do |md_file|
  puts "Processing : #{md_file}"
  md = File.read(md_file)

  vector_db.load(md)

  sleep 20.seconds
end
