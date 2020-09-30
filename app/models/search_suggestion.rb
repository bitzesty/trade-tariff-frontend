require 'api_entity'

class SearchSuggestion
  include ApiEntity

  collection_path '/search_suggestions'

  attr_accessor :value

  def self.cached_suggestions
    Rails.cache.fetch('cached_search_suggestions', expires_in: 24.hours) do
      all
    end
  end

  def self.start_with(term)
    cached_suggestions.select { |s| s.value =~ /^#{term}/i }
                      .first(TradeTariffFrontend.suggestions_count)
  end
end
