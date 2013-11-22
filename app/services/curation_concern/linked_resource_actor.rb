module CurationConcern
  class LinkedResourceActor < BaseActor
    LinkedResource.editable_attributes.each do |attribute|
      attribute attribute.name
    end
  end
end
