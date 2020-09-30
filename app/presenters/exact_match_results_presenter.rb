class ExactMatchResultsPresenter
  def initialize(search, search_results)
    @search_results = search_results
    @search = search
  end

  def as_json(_opts = {})
    klass = @search_results.entry['endpoint'].singularize.camelize.constantize
    entity = klass.find(@search_results.entry['id'], as_of: @search.date.to_s)
    [ "::SearchResult::#{entity.class.name}Serializer".constantize.new(entity).as_json(_opts) ]
  end
end