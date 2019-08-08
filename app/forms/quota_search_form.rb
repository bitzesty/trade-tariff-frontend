class QuotaSearchForm
  CRITICAL_VALUES = { 'Yes' => 'Y', 'No' => 'N' }.freeze
  STATUS_VALUES = %w(Blocked Exhausted Not\ blocked Not\ exhausted).freeze
  YEAR_VALUES = %w(2016 2017 2018 2019 2020).freeze
  DEFAULT_YEAR_VALUE = Date.current.year.to_s.freeze

  attr_accessor :goods_nomenclature_item_id, :geographical_area_id, :order_number, :critical, :status, :year

  def initialize(params)
    params.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=") && value.present?
    end
  end

  def year
    Array.wrap(@year || DEFAULT_YEAR_VALUE)
  end

  def present?
    instance_variables.present?
  end

  def geographical_area
    GeographicalArea.countries.find do |country|
      country.id == geographical_area_id
    end
  end

  def to_params
    {
      goods_nomenclature_item_id: goods_nomenclature_item_id,
      geographical_area_id: geographical_area_id,
      order_number: order_number,
      critical: critical,
      status: status,
      year: year
    }
  end
end
