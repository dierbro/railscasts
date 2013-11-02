class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :published_at, :seconds, :position, :permalink
end

