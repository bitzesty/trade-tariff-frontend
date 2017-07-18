class CommoditiesController < GoodsNomenclaturesController
  def show
    @commodity = CommodityPresenter.new(Commodity.find(params[:id], query_params))
    @heading = @commodity.heading
    @chapter = @commodity.chapter
    @section = @commodity.section
    @back_path = "#{headings_path}/#{@heading.short_code}"
  end

  private

  def commodities_by_code
    search_term = Regexp.escape(params[:term].to_s)
    Commodity.by_code(search_term).sort_by(&:code)
  end
end
