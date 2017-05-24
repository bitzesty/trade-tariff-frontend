require 'spec_helper'

describe Commodity do

  describe "parent/children relationships" do
    let(:associated_commodities) {
                                   {
                                    commodities: [attributes_for(:commodity, goods_nomenclature_sid: 1,
                                                                             parent_sid: nil),
                                                  attributes_for(:commodity, parent_sid: 1,
                                                                             goods_nomenclature_sid: 2)]
                                   }
                                 }
    let(:heading_attributes) { attributes_for(:heading).merge(associated_commodities) }
    let(:heading) { Heading.new(heading_attributes) }

    describe "#children" do
      it 'returns list of commodities children' do
        heading

        expect(heading.commodities.first.children).to include heading.commodities.last
      end

      it 'returns empty array if commodity does not have children' do
        heading

        expect(heading.commodities.last.children).to be_blank
      end
    end

    describe "#root" do
      it 'returns children that have no parent_sid set' do
        heading

        root_children = heading.commodities.select(&:root)
        expect(root_children).to     include heading.commodities.first
        expect(root_children).to_not include heading.commodities.last
      end
    end

    describe "#leaf?" do
      let(:commodity_non_leaf) { heading.commodities.first }
      let(:commodity_leaf)     { heading.commodities.last }

      it 'returns true if it is a left and false otherwise' do
        expect(commodity_non_leaf.leaf?).to be false
        expect(commodity_leaf.leaf?).to be true
      end
    end
  end

  describe "#to_param" do
    let(:commodity) { Commodity.new(attributes_for :commodity) }

    it 'returns commodity code as param' do
      expect(commodity.to_param).to eq commodity.code
    end
  end

  describe '.all', vcr: { cassette_name: "commodities#codes" }  do
    let(:commodities) { Commodity.all }

    it 'fetches commodities from the API' do
      expect(commodities).to be_kind_of Array
      expect(commodities).to_not be_blank
    end

    it 'sorts commodities by code' do
      expect(commodities.first.code).to be < commodities.last.code
    end
  end

  describe '.by_code', vcr: { cassette_name: 'commodities#codes', allow_playback_repeats: true  } do
    it 'invokes .cached_commodities method' do
      expect(described_class).to receive(:cached_commodities) { [] }
      described_class.by_code('123')
    end

    it 'returns commodities filtered by code' do
      codes = Commodity.all
      expect(described_class.by_code(codes[0].code.first(4)).map(&:code)).to include(codes[0].code)
    end
  end
end
