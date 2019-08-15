class FootnoteSearchForm
  attr_accessor :code, :type, :description

  def initialize(params)
    params.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=") && value.present?
    end
  end

  def footnote_types
    Rails.cache.fetch('cached_footnote_types', expires_in: 24.hours) do
      FootnoteType.all&.sort_by(&:footnote_type_id).map do |type|
        [ "#{type&.footnote_type_id} - #{type&.description}", type&.footnote_type_id ]
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
