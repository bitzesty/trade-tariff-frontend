require 'api_entity'

class Footnote
  include ApiEntity

  ECO_CODE = '05002'

  attr_accessor :code, :description, :formatted_description

  def id
    @id ||= "#{casted_by.destination}-#{casted_by.id}-footnote-#{code}"
  end

  def eco?
    code == ECO_CODE
  end
end
