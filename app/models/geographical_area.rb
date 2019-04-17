require 'api_entity'

class GeographicalArea
  include ApiEntity

  collection_path '/geographical_areas/countries'

  attr_accessor :id, :description, :geographical_area_id

  has_many :children_geographical_areas, class_name: 'GeographicalArea'

  def self.countries
    excluded_geographical_area_ids = %w[GB]

    all.sort_by(&:id)
       .reject { |country| country.id.in?(excluded_geographical_area_ids) }
  end

  def self.cached_countries
    Rails.cache.fetch(
      'cached_countries',
      expires_in: 24.hours
    ) do
      countries
    end
  end
  
  def self.areas
    collection('/geographical_areas').sort_by(&:id)
  end
  
  def self.cached_areas
    Rails.cache.fetch(
      'areas',
      expires_in: 24.hours
    ) do
      areas
    end
  end

  def self.by_long_description(term)
    lookup_regexp = /#{term}/i
    cached_countries.select do |country|
      country.long_description =~ lookup_regexp
    end.sort_by do |country|
      match_id = country.id =~ lookup_regexp
      match_desc = country.description =~ lookup_regexp
      key = ""
      key << (match_id ? "0" : "1")
      key << (match_desc || '')
      key << country.id
      key
    end
  end

  def description
    attributes['description'].presence || ''
  end

  def long_description
    "#{description} (#{id})"
  end

  def to_s
    description
  end
end
