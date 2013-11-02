class EpisodeDetailedSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :published_at, :seconds, :comments, :notes, :position, :permalink
end
