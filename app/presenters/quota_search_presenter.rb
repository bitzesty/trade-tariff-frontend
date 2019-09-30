class QuotaSearchPresenter
  attr_reader :search_form, :search_result, :with_errors
  
  def initialize(search_form)
    @with_errors = false
    @search_form = search_form
    begin
      @search_result = OrderNumber::Definition.search(search_form.to_params).sort_by(&:quota_order_number_id) if search_form.present?
    rescue StandardError
      @with_errors = true
    end
  end
end
