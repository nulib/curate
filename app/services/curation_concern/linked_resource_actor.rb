module CurationConcern
  class LinkedResourceActor < CurationConcern::BaseActor
    curation_concern_type.editable_attributes.each do |attribute|
      attribute attribute.name
    end
  end
end
