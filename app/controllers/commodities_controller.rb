class CommoditiesController < GoodsNomenclaturesController
  def show
    @commodity = CommodityPresenter.new(Commodity.find(params[:id], query_params))
    @heading = HeadingPresenter.new(Heading.find(@commodity.heading.short_code, query_params))
    @chapter = @commodity.chapter
    @section = @commodity.section
    @back_path = heading_path(@heading.short_code)
    @commodity.prev, @commodity.next = set_prev_next
  end

  private

  def commodities_by_code
    search_term = Regexp.escape(params[:term].to_s)
    Commodity.by_code(search_term).sort_by(&:code)
  end

  def set_prev_next(heading = @heading, commodity = @commodity)
    gnids = heading.commodities.select(&:leaf?).map(&:goods_nomenclature_item_id)
    i = gnids.index(commodity.goods_nomenclature_item_id)
    return [
      i == 0 ? nil : gnids[i-1],
      i == (gnids.length - 1) ? nil : gnids[i+1]
    ]
  end
end
