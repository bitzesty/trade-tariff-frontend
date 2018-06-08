module MeasuresHelper
  def order_number_info(record)
    record.definition.try(:description) || "Order number #{record.number}"
  end

  def filter_duty_expression(record)
    (record.include? 'NIHIL') ? '' : record
  end
end
