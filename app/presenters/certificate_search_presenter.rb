class CertificateSearchPresenter
  attr_reader :search_form, :search_result

  def initialize(search_form)
    @search_form = search_form
    @search_result = Certificate.search(search_form.to_params).sort_by(&:code) if search_form.present?
  end
end
