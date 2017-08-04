require 'api_entity'
require 'ostruct'
require 'search/base_match'

class Search
  include ApiEntity

  class CasNumberMatch < BaseMatch
    BLANK_RESULT = OpenStruct.new(
      cas_numbers: []
    )

    attr_accessor :cas_numbers

    def initialize(entries)
      @cas_numbers = entries[:cas_numbers].map do |e|
        OpenStruct.new(
          title: e[:_source][:title],
          chapter: Chapter.new(e[:_source][:chapter]),
          heading: Heading.new(e[:_source][:heading]),
          commodities: e[:_source][:commodities].map{ |c| Commodity.new(c) }
        )
      end
    end

    def any?
      cas_numbers.any?
    end

    def all
      cas_numbers
    end

    def size
      all.size
    end
  end
end
