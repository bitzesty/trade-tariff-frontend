module LinkingHelper
  CONNECTORS = ['and', 'or', ',']

  def apply_links text
    parts = text.gsub(/([\.,])/, ' \1').split(" ")
    strategy = method(:nil_state)
    parts.each_with_index do |part, index|
      if part == 'heading'
        strategy = method(:heading_state)
      elsif CONNECTORS.include? part
        # skip
      elsif part == '.' || !numeric?(part)
        strategy = method(:nil_state)
      else
        parts[index] = strategy.call(part)
      end
    end
    parts.join(" ").gsub(/ ([\.,])/, '\1')
  end

  def number_to_heading_link number
    link_to(number, heading_path(number))
  end

  private

  def nil_state part
    return part
  end

  def heading_state part
    if numeric? part
      number_to_heading_link(part)
    else
      part
    end
  end

  def numeric? str
    return true if str =~ /^\d+$/
  end
end