require 'spec_helper'

describe Footnote do
  describe '#id' do
    let(:measure) { Measure.new(attributes_for(:measure, id: '123').stringify_keys) }
    let(:footnote) { described_class.new(attributes_for(:footnote, casted_by: measure, code: '456').stringify_keys) }

    it 'should contain casted_by info' do
      expect(footnote.id).to include(footnote.casted_by.destination)
      expect(footnote.id).to include(footnote.casted_by.id)
    end

    it 'should contain code' do
      expect(footnote.id).to include(footnote.code)
    end

    it "should contain '-footnote-'" do
      expect(footnote.id).to include('-footnote-')
    end
  end

  describe '#eco?' do
    let(:footnote) { described_class.new(attributes_for(:footnote, code: described_class::ECO_CODE).stringify_keys) }
    let(:footnote1) { described_class.new(attributes_for(:footnote).stringify_keys) }

    it 'returns true if ECO code' do
      expect(footnote.eco?).to be_truthy
    end

    it 'returns false if not ECO code' do
      expect(footnote1.eco?).to be_falsey
    end
  end
end
