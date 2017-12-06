class HeadingsController < GoodsNomenclaturesController
  def show
    @heading = HeadingPresenter.new(Heading.find(params[:id], query_params))
    @commodities = HeadingCommodityPresenter.new(@heading.commodities)
    @back_path = chapter_path(@heading.chapter.short_code)
  end
end
