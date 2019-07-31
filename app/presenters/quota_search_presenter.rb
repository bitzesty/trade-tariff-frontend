class QuotaSearchPresenter
  attr_reader :search_form, :search_result
  
  def initialize(search_form)
    @search_form = search_form
    @search_result = OrderNumber::Definition.search(search_form.to_params).sort_by(&:quota_order_number_id) if search_form.present?
  end
end