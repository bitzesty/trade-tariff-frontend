class SearchResultsPresenter
  def initialize(search_results)
    @search_results = search_results
  end

  def as_json(_opts = {})
    flattened_search_results.map do |entity|
      "::SearchResult::#{entity.class.name}Serializer".constantize.new(entity).as_json(_opts)
    end
  end

  private

  def flattened_search_results
    [
      @search_results.goods_nomenclature_match.sections,
      @search_results.goods_nomenclature_match.chapters,
      @search_results.goods_nomenclature_match.headings,
      @search_results.goods_nomenclature_match.commodities
    ].reduce([], :concat)
  end
end
