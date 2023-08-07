require "dotenv/load"
require "active_record"
require "neighbor"

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
    t.string :page
    t.text :content
    t.vector :embedding, limit: 1536

    t.timestamps
  end
end

json = JSON.parse(File.read("languages.json"))
VectorDatabase.new.load(json)
