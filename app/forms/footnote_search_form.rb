class FootnoteSearchForm
  attr_accessor :code, :description

  def initialize(params)
    params.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=") && value.present?
    end
  end

  def present?
    instance_variables.present?
  end

  def to_params
    {
      code: code,
      description: description,
    }
  end
end
