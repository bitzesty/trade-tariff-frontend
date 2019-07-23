class SearchPresenter
  def initialize(search, results)
    @search = search
    @search_results = SearchResultsPresenter.new(results)
  end

  def as_json(opts = {})
    {
      q: @search.q,
      as_of: @search.date.to_s,
      results: @search_results.as_json(opts)
    }
  end
end
