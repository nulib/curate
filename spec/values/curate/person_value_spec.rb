require 'spec_helper'

module Curate
  describe PersonValue do
    let(:name) { nil }
    let(:identifier) { nil }
    let(:attributes) {
      {
        name: name,
        id: identifier
      }
    }
    subject { described_class.new(attributes) }

    it { should delegate(:with_indifferent_access).to(:attributes) }

    context 'with a name' do
      let(:name) { 'Jack Kennedy' }
      its(:as_rdf_object) { should be_a_kind_of(RDF::Literal) }
    end

    context 'with an identifier' do
      let(:identifier) { 'ab12cd34ef56' }
      let(:identified_object) { double(as_rdf_object: :as_rdf_object) }
      before(:each) do
        Person.should_receive(:find).with(identifier).and_return(identified_object)
      end
      its(:as_rdf_object) { should eq(identified_object.as_rdf_object) }
    end
  end
end
