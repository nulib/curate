module CurationConcern
  class LinkedResourceActor < CurationConcern::BaseActor
    LinkedResource.editable_attributes.each do |attribute|
      attribute attribute.name
    end
  end
end
