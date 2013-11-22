module CurationConcern
  class GenericWorkActor < CurationConcern::AbstractWorkActor

    GenericWork.editable_attributes do |a|
      attribute a.name
    end

  end
end
