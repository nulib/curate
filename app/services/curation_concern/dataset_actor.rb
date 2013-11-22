module CurationConcern
  class DatasetActor < WorkActor
    Dataset.editable_attributes.each do |config|
      attribute config.name
    end
  end
end
