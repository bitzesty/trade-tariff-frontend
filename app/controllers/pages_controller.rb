class PagesController < ApplicationController
  layout "pages"

  def index
    @section_css = 'visuallyhidden'
    @meta_description = I18n.t('meta_description')
  end

  def opensearch
    respond_to do |format|
      format.xml
    end
  end

  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end

  def exchange_rates
    all_rates = MonetaryExchangeRate.all
    @rates = {}

    all_rates.each do |rate|
      if @rates[rate.validity_start_date.year].blank?
        @rates[rate.validity_start_date.year.to_i] = []
      end

      @rates[rate.validity_start_date.year.to_i] << rate
    end

    @rates.each do |k,v|
      v.sort_by! { |rate| rate.validity_start_date }
    end

    @years = @rates.keys.sort.reverse
  end
end
