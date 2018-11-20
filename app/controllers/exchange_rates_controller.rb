class ExchangeRatesController < ApplicationController
  def index
    all_rates = MonetaryExchangeRate.all
    @last_updated = all_rates.last.operation_date.strftime("%d %B %Y")
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

    @current_rate = all_rates.last
  end
end
