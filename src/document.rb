class Document < ActiveRecord::Base
  has_neighbors :embedding
  has_many :chunks
end
