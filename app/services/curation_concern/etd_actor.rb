module CurationConcern
  class EtdActor < AbstractWorkActor
    Etd.editable_attributes.each do |config|
      attribute config.name
    end
  end
end
