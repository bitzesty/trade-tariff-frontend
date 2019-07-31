require 'api_entity'

class AdditionalCode
  include ApiEntity

  collection_path '/additional_codes'

  attr_accessor :code, :description, :formatted_description

  has_one :measure

  def id
    @id ||= "#{casted_by.destination}-#{casted_by.id}-additional-code-#{code}"
  end

  def present?
    code.present?
  end

  def to_s
    code
  end
end
