module CurationConcern
  class ImageActor < AbstractWorkActor
    Image.editable_attributes.each do |config|
      attribute config.name
    end
  end
end
