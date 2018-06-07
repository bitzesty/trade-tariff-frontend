module MeasuresHelper
  def order_number_info(record)
    record.definition.try(:description) || "Order number #{record.number}"
  end
end
