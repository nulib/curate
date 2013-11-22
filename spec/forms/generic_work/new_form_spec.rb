require 'spec_helper'

module Curate

  class PersonReference
    include Virtus.value_object

    values do
      attribute :name
      attribute :identifier
    end

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
        if identifier.present?
          Person.find(identifier)
        else
          ''
        end
      rescue ActiveFedora::ObjectNotFoundError
        ''
      end
    end
  end

  class GenericWork::NewForm

    include ::Virtus.model
    include ActiveModel::Validations

    def self.model_name
      GenericWork.model_name
    end

    delegate :persisted?, :to_param, :to_key, :to_partial_path, to: :@generic_work
    def initialize(generic_work, attributes = {}, &block)
      @generic_work = generic_work
      super(attributes, &block)
    end

    # required_information
    attribute :title, String
    validates :title, presence: true

    attribute :contributors, Array[Curate::PersonReference]
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
    validates :rights, presence: true, inclusion: { in: Sufia.config.cc_licenses.keys }

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

  end

  describe GenericWork::NewForm do
    let(:generic_work) { GenericWork.new }

    context 'class methods' do
      subject { described_class }
      its(:model_name) { should eq generic_work.class.model_name }
    end

    context 'delegated methods' do
      subject { described_class.new(generic_work) }

      it { should delegate(:persisted?).to(:@generic_work) }
      it { should delegate(:to_param).to(:@generic_work) }
      it { should delegate(:to_key).to(:@generic_work) }
      it { should delegate(:to_partial_path).to(:@generic_work) }
    end

    context 'persistence' do

      let(:contributor_by_name) { { name: 'Davy Jones' } }
      let(:contributor_by_identifier) { { name: FactoryGirl.create(:person).noid } }
      let(:attributes) do
        {
          title: 'My Title',
          description: 'Lore',
          contributors: [contributor_by_name, contributor_by_identifier]
        }
      end

      context 'with valid attributes' do
        subject { described_class.new(generic_work, attributes) }
        it { should be_valid }

        it 'should persist a generic work' do
          expect {
            subject.save
          }.to change(GenericWork, :count).by(1)
        end
      end

    end
  end
end
