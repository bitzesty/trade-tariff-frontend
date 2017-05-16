require 'api_entity'

class Search
  include ApiEntity

  attr_accessor :q,       # search text query
                :country, # search country
                :day,
                :month,
                :year,
                :as_of    # legacy format for specifying date

  delegate :today?, to: :date

  def perform
    response = self.class.post('/search', body: { t: q, as_of: date.to_s(:db) })

    raise ApiEntity::Error if response.code == 500

    Outcome.new(response)
  end

  def q=(val)
    @q = val.to_s.gsub(/(\[|\])/, '')
  end

  def countries
    [ geographical_area ].compact
  end

  def geographical_area
    GeographicalArea.cached_countries.detect do |country|
      country.id == attributes['country']
    end
  end

  def date
    @date ||= if as_of.present?
                TariffDate.new(as_of)
              else
                TariffDate.parse(attributes.slice(*TariffDate::DATE_KEYS))
              end
  end

  def filtered_by_date?
    date.date != Date.current
  end

  def filtered_by_country?
    country.present?
  end

  def any_filter_active?
    filtered_by_date? || filtered_by_country?
  end

  def contains_search_term?
    q.present?
  end

  def query_attributes
    { 'day'  => date.day,
      'year' => date.year,
      'month' => date.month }.merge(attributes.slice(:country))
  end

  def to_s
    q
  end

  def id
    q
  end
end
