class SearchByAdditionalCodePresenter
  attr_reader :search_form, :search_result

  def initialize(search_form)
    @search_form = search_form
    @search_result = AdditionalCode.search(search_form.to_params).sort_by do |additional_code|
      additional_code&.measure&.goods_nomenclature&.goods_nomenclature_item_id
    end if search_form.present?
  end
end