class ContentItem < ActiveRecord::Base
  has_neighbors :embedding
end
