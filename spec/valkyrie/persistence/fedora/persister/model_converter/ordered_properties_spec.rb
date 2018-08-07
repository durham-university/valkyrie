# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Valkyrie::Persistence::Fedora::Persister::ModelConverter::OrderedProperties do

  describe '.handles?' do
    let(:value) { Valkyrie::Persistence::Fedora::Persister::ModelConverter::Property.new }
    let(:resource) { instance_double(Valkyrie::Resource) }
    let(:property_value) { instance_double(Dry::Types::Sum) }
    let(:schema) do
      {
        title: property_value
      }
    end
    let(:uri) { instance_double(RDF::URI) }

    before do
      allow(property_value).to receive(:meta).and_return({ ordered: true })

      allow(resource.class).to receive(:schema).and_return(schema)
      allow(value).to receive(:resource).and_return(resource)
      allow(value).to receive(:key).and_return(:title)
      allow(value).to receive(:value).and_return(uri)
    end

    it 'delegates to the .ordered? method' do
      expect(described_class.handles?(value)).to eq(described_class.ordered?(value))
    end

    it 'determines if the value is a Property with a URI' do
      expect(described_class.handles?(value)).to be true
    end
  end

  describe '.ordered?' do
    let(:value) { Valkyrie::Persistence::Fedora::Persister::ModelConverter::Property.new }
    let(:resource) { instance_double(Valkyrie::Resource) }
    let(:property_value) { instance_double(Dry::Types::Sum) }
    let(:schema) do
      {
        title: property_value
      }
    end
    let(:uri) { instance_double(RDF::URI) }

    before do
      allow(resource.class).to receive(:schema).and_return(schema)
      allow(value).to receive(:resource).and_return(resource)
      allow(value).to receive(:key).and_return(:title)
      allow(value).to receive(:value).and_return(uri)
    end

    it 'determines if the value can be mapped using the property metadata' do
      allow(property_value).to receive(:meta).and_return({ ordered: true })

      expect(described_class.handles?(value)).to be true
    end

    context 'when the default metadata is used' do
      it 'determines that values cannot be ordered' do
        allow(property_value).to receive(:meta).and_return({})

        expect(described_class.handles?(value)).to be false
      end
    end
  end

  describe '#result' do

  end

  describe '#graph' do

  end

  describe '#apply_first_and_last' do

  end

  describe '#node_id' do

  end

  describe '#predicate' do

  end

  describe '#initialize_list' do

  end

  describe '#ordered_list' do

  end
end
