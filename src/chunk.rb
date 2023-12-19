class Chunk < ActiveRecord::Base
  has_neighbors :embedding
  belongs_to :document
end
