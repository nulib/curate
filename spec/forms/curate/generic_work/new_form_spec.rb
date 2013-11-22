require 'spec_helper'

module Curate

  describe GenericWork::NewForm do
    let(:user) { FactoryGirl.stubbed_model(:user) }
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
        subject { described_class.new(generic_work, user, attributes) }
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
