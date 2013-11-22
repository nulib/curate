module Curate
  class PersonValue
    include Virtus.value_object

    values do
      attribute :name
      attribute :id
    end

    delegate :with_indifferent_access, to: :attributes

    def as_rdf_object
      if identified_object.present?
        identified_object.as_rdf_object
      else
        RDF::Literal.new(name)
      end
    end

    private
    def identified_object
      @identified_object ||=
      begin
        if id.present?
          Person.find(id)
        else
          ''
        end
      rescue ActiveFedora::ObjectNotFoundError
        ''
      end
    end
  end
end
