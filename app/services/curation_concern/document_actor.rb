module CurationConcern
  class DocumentActor < GenericWorkActor

    # required_information
    attribute :title, String
    validates :title, presence: true

    attribute :contributors_attributes, Hash[String => Curate::PersonValue]
    validates :contributors_attributes, presence: true

    attribute :contributors, Array[Curate::PersonValue], default: :default_contributors

    attribute :description, String
    validates :description, presence: true

    # form_additional_information
    attribute :subject, Array[String]
    attribute :publisher, Array[String]
    attribute :bibliographic_citation, Array[String]
    attribute :source, Array[String]
    attribute :language, Array[String]

    # form_files_and_links
    attribute :files, Array[String]
    attribute :linked_resource_urls, Array[String]

    # form_representative_image
    attribute :representative, String

    # form_doi
    attribute :identifier, String
    attribute :doi_assignment_strategy, String
    attribute :existing_identifier, String


    # Given that a publisher could be an array or a single entity
    # Then we need to account for both
    # Conveniently [].length == 0 and "".length == 0
    validates :publisher, length: { minimum: 1, message: 'is required for remote DOI minting', if: :remote_doi_assignment_strategy? }

    attr_writer :doi_remote_service

    protected

    def doi_remote_service
      @doi_remote_service ||= Hydra::RemoteIdentifier.remote_service(:doi)
    end

    def remote_doi_assignment_strategy?
      doi_assignment_strategy.to_s == doi_remote_service.accessor_name.to_s
    end

    # form_content_license
    attribute :rights, String, default: :default_rights
    validates :rights, presence: true, inclusion: { in: :valid_rights }

    attribute :type, String
    validates :type, inclusion: { in: Document.valid_types, allow_blank: true }

    def default_contributors
      if ! self.contributors.present?
        self.contributors = [Curate::PersonValue.new(name: user.name, id: user.repository_id)]
      end
    end
  end
end
