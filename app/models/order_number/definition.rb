require 'api_entity'
require 'null_object'

class OrderNumber
  class Definition
    include ApiEntity

    collection_path '/quotas'

    DATE_FIELDS = %w[blocking_period_start_date blocking_period_end_date
                     suspension_period_start_date suspension_period_end_date
                     validity_start_date validity_end_date last_allocation_date].freeze

    attr_accessor :initial_volume, :status, :measurement_unit,
                  :measurement_unit_qualifier,
                  :monetary_unit, :balance, :description

    DATE_FIELDS.each do |field|
      define_method(field.to_sym) do
        instance_variable_get("@#{field}".to_sym).presence || NullObject.new
      end

      define_method("#{field}=".to_sym) do |arg|
        instance_variable_set("@#{field}".to_sym, Time.parse(arg)) if arg.present?
      end
    end

    has_one :order_number
    
    def present?
      status.present?
    end
  end
end
