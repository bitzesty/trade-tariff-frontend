require 'api_entity'

class MeasureCondition
  include ApiEntity

  attr_accessor :condition_code, :condition, :document_code, :requirement, :action, :duty_expression
end
