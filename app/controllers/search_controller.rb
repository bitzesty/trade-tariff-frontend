require 'addressable/uri'

class SearchController < ApplicationController
  def search
    @results = @search.perform

    respond_to do |format|
      format.html do
        if @search.contains_search_term?
          redirect_to url_for(@results.to_param.merge(url_options)) if @results.exact_match?
        else
          if request.referer
            back_url = Addressable::URI.parse(request.referer)
            back_url.query_values ||= {}
            back_url.query_values = back_url.query_values.merge(@search.query_attributes)
            if @search.date.today?
              back_url.query_values = back_url.query_values.except('year', 'month', 'day')
            end
            return_to = back_url.to_s
          else
            return_to = sections_url
          end

          anchor = if params.dig(:search, :anchor).present?
                     if params[:search][:anchor] == 'import'
                       '#import'
                     else
                       '#export'
                     end
                   else
                     ''
          end

          redirect_to(return_to + anchor)
        end
      end

      format.json {
        render json: SearchPresenter.new(@search, @results)
      }

      format.atom
    end
  end

  def suggestions
    search_term = Regexp.escape(params[:term].to_s)
    start_with = SearchSuggestion.start_with(search_term).sort_by(&:value)
    results = start_with.map { |s| { id: s.value, text: s.value } }

    render json: { results: results }
  end

  def quota_search
    form = QuotaSearchForm.new(params)
    @result = QuotaSearchPresenter.new(form)
    respond_to do |format|
      format.html
    end
  end
end
