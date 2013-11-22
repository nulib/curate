module CurationConcern
  class DatasetActor < AbstractWorkActor
    Dataset.editable_attributes.each do |config|
      attribute config.name
    end
  end
end
