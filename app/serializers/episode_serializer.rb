class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :published_at, :seconds
end

