class FootnoteSearchPresenter
  attr_reader :search_form, :search_result

  def initialize(search_form)
    @search_form = search_form
    @search_result = Footnote.search(search_form.to_params) if search_form.present?
  end
end
