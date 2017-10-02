require 'spec_helper'

describe Measure do
  describe "#relevant_for_country?" do
    it 'returns true when no geographical area is specified' do
      measure = Measure.new(attributes_for(:measure, :eu, geographical_area: {id: 'br',
                                                                         description: 'Brazil'}))
      expect(
        measure.relevant_for_country?(nil)
      ).to eq true
    end

    it 'returns true if a national measure and geographical area code is equal to 1011' do
      measure = Measure.new(attributes_for(:measure, :national, geographical_area: {id: '1011',
                                                                         description: 'ERGA OMNES'}))
      expect(
        measure.relevant_for_country?('br')
      ).to eq true
    end

    it 'returns false if a national measure and it is an excluded country' do
      measure = Measure.new(attributes_for(:measure, :national, geographical_area: {id: 'lt',
                                                                         description: 'Lithuania'},
                                                                         excluded_countries: [
                                                                          {id: 'lt', description: 'Lithuania', geographical_area_id: 'lt'}
                                                                         ]))
      expect(
        measure.relevant_for_country?('lt')
      ).to eq false
    end

    it 'returns true if geographical area code matches' do
      measure = Measure.new(attributes_for(:measure, :eu, geographical_area: {id: 'br',
                                                                         description: 'Brazil'}))
      expect(
        measure.relevant_for_country?('br')
      ).to eq true
      expect(
        measure.relevant_for_country?('fr')
      ).to eq false
    end

    it 'returns true if geographical area (group) contains matching code' do
      measure = Measure.new(attributes_for(:measure, :eu, geographical_area: {id: nil,
                                                                         description: 'European Union',
                                                                         children_geographical_areas: [
                                                                           {id: 'lt', description: 'Lithuania'},
                                                                           {id: 'fr', description: 'France'}
                                                                         ]}))
      expect(
        measure.relevant_for_country?('lt')
      ).to eq true
      expect(
        measure.relevant_for_country?('it')
      ).to eq false
    end

    it 'returns false if country code is among excluded countries for this measure' do
      measure = Measure.new(attributes_for(:measure, :eu, geographical_area: {id: nil,
                                                                         description: 'European Union',
                                                                         children_geographical_areas: [
                                                                           {id: 'lt', description: 'Lithuania', geographical_area_id: 'lt'}
                                                                         ]},
                                                     excluded_countries: [
                                                                          {id: 'lt', description: 'Lithuania', geographical_area_id: 'lt'}
                                                                         ]))
      expect(
        measure.relevant_for_country?('lt')
      ).to eq false
    end
  end

  describe '#key' do
    it 'has 0 in the 0 position for ERGA OMNES' do
      measure = Measure.new(
        attributes_for(:measure, :national, geographical_area: {id: '1011', description: 'ERGA OMNES'})
      )
      expect(measure.key[0]).to eq('0')
    end

    it 'has 1 in the 0 position for not ERGA OMNES' do
      measure = Measure.new(
        attributes_for(:measure, :national, geographical_area: {id: '1234', description: 'Other'})
      )
      expect(measure.key[0]).to eq('1')
    end

    it 'has 0 in the 1 position for national' do
      measure = Measure.new(
        attributes_for(:measure, :national, geographical_area: {id: '1234', description: 'Other'})
      )
      expect(measure.key[1]).to eq('0')
    end

    it 'has 1 in the 1 position for not national' do
      measure = Measure.new(
        attributes_for(:measure, :eu, geographical_area: {id: '1234', description: 'Other'})
      )
      expect(measure.key[1]).to eq('1')
    end

    it 'has 0 in the 2 position for vat' do
      measure = Measure.new(
        attributes_for(:measure, :eu, vat: true, geographical_area: {id: '1234', description: 'Other'})
      )
      expect(measure.key[2]).to eq('0')
    end

    it 'has 1 in the 2 position for not vat' do
      measure = Measure.new(
        attributes_for(:measure, :eu, geographical_area: {id: '1234', description: 'Other'})
      )
      expect(measure.key[2]).to eq('1')
    end
  end
end
