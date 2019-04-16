require 'api_entity'
require 'order_number/definition'

class OrderNumber
  include ApiEntity

  collection_path "/quotas"
  
  attr_accessor :number

  delegate :present?, to: :number

  has_one :definition
  has_one :geographical_area

  def id
    @id ||= "#{casted_by.destination}-#{casted_by.id}-order-number-#{number}"
  end

  def has_definition?
    definition.present?
  end
end
