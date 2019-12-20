class QuestionSerializer < ActiveModel::Serializer
  attributes :title, :description, :tags, :slug, :views
end
