require 'spec_helper'

module Curate
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

    attribute :title

    validates :title, presence: true

  end

  describe GenericWork::NewForm do
    let(:generic_work) { GenericWork.new }

    context 'class methods' do
      subject { described_class }
      its(:model_name) { should eq generic_work.class.model_name }
    end

    context 'instance methods' do
      subject { described_class.new(generic_work) }

      it { should delegate(:persisted?).to(:@generic_work) }
      it { should delegate(:to_param).to(:@generic_work) }
      it { should delegate(:to_key).to(:@generic_work) }
      it { should delegate(:to_partial_path).to(:@generic_work) }
    end

    context 'attributes' do
      let(:attributes) do
        {
          'title' => 'My Title'
        }
      end
      subject { described_class.new(generic_work, attributes) }

      its(:title) { should eq attributes.fetch('title') }
    end
  end
end
