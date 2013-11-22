module CurationConcern
  class DocumentActor < GenericWorkActor

    # required_information
    attribute :title, String
    validates :title, presence: true

    attribute :contributors_attributes, Hash[String => Curate::PersonValue]
    validates :contributors, presence: true

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
    attribute :doi_assignment_strategy, String

    # form_permission
    attribute :visibility, String

    # form_content_license
    attribute :rights, String, default: :default_rights
    validates :rights, presence: true, inclusion: { in: :valid_rights }

    attribute :type, String
    validates :type, inclusion: { in: Document.valid_types, allow_blank: true }

  end
end
