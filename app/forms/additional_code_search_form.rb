class AdditionalCodeSearchForm
  attr_accessor :code, :type, :description

  def initialize(params)
    params.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=") && value.present?
    end
  end

  def additional_code_types
    Rails.cache.fetch('cached_additional_code_types', expires_in: 24.hours) do
      AdditionalCodeType.all&.sort_by(&:additional_code_type_id).map do |type|
        [ "#{type&.additional_code_type_id} - #{type&.description}", type&.additional_code_type_id ]
      end.to_h
    end
  end

  def present?
    instance_variables.present?
  end

  def to_params
    {
      code: code,
      type: type,
      description: description,
    }
  end
end
