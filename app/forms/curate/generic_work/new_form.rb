module Curate

  class GenericWork::NewForm

    include ::Virtus.model
    include ActiveModel::Validations

    def self.model_name
      GenericWork.model_name
    end

    delegate :persisted?, :to_param, :to_key, :to_partial_path, to: :@generic_work
    def initialize(generic_work, user, attributes = {}, &block)
      @generic_work = generic_work
      @user = user
      super(attributes, &block)
    end

    # required_information
    attribute :title, String
    validates :title, presence: true

    attribute :contributors, Array[Curate::PersonValue]
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

    def save
      valid? ? persist : false
    end

    protected

    def persist
      @generic_work.attributes = attributes
      @generic_work.save
    end

    def default_rights
      Sufia.config.cc_licenses['All rights reserved']
    end

    def valid_rights
      Sufia.config.cc_licenses.keys
    end

  end
end
