class CertificateSearchPresenter
  attr_reader :search_form, :search_result, :with_errors

  def initialize(search_form)
    @with_errors = false
    @search_form = search_form
    @search_result = Certificate.search(search_form.to_params).sort_by(&:code) if search_form.present?
  rescue StandardError
    @with_errors = true
  end
end
