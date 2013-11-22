module CurationConcern
  class ImageActor < WorkActor
    Image.editable_attributes.each do |config|
      attribute config.name
    end

  end
end
