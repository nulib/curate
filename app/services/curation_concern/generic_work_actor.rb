module CurationConcern
  class GenericWorkActor < AbstractWorkActor

    GenericWork.editable_attributes do |a|
      attribute a.name
    end

  end
end
