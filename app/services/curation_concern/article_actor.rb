module CurationConcern
  class ArticleActor < AbstractWorkActor
    Article.editable_attributes do |config|
      attribute config.name
    end
  end
end
