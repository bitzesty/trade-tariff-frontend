module CommoditiesHelper
  def leaf_position(commodity)
    if commodity.last_child?
      " last-child"
    end
  end

  def commodity_level(commodity)
    "level-#{commodity.number_indents}"
  end

  def commodity_tree(main_commodity, commodities)
    if commodities.any?
      content_tag(:ul, class: 'commodities') do
        content_tag(:li) do
          content_tag(:p, commodities.first.to_s.html_safe) +
          tree_code(commodities.first.code) + 
          tree_node(main_commodity, commodities, commodities.first.number_indents)
        end
      end
    else
      content_tag(:ul, class: 'commodities') do
        content_tag(:li, commodity_heading(main_commodity))
      end
    end
  end

  def tree_chapter_code(chapter)
    code = chapter.short_code
    tree_code(code)
  end

  def tree_heading_code(heading)
    code = heading.short_code
    tree_code(code)
  end

  def tree_commodity_code(declarable)
    code = declarable.code.to_s
    tree_code(code)
  end

  def tree_code(code, klass: 'full-code')
    "<div class='#{klass}'>
      #{chapter_and_heading_codes(code)}
      <div class='commodity-code'>
        #{code_text(code[4..5])}
        #{code_text(code[6..7])}
        #{code_text(code[8..9])}
      </div>
    </div>".html_safe
  end

  def format_full_code(commodity)
    code = commodity.code.to_s
    tree_code(code, klass: nil)
  end

  def format_commodity_code(commodity)
    code = commodity.display_short_code.to_s
    "#{code[0..1]}&nbsp;#{code[2..3]}&nbsp;#{code[4..-1]}".html_safe
  end

  def format_commodity_code_based_on_level(commodity)
    code = commodity.code.to_s
    display_full_code = commodity.producline_suffix == '80'

    if commodity.number_indents > 1 || display_full_code
      # remove trailing pairs of zeros for non declarable
      code = code.gsub(/[0]{2}+$/, '') if commodity.has_children?
      tree_code(code, klass: nil)
    end
  end

  private

  def chapter_and_heading_codes(code)
    "<div class='chapter-code'>
      #{code_text(code[0..1])}
    </div>
    <div class='heading-code'>
      #{code_text(code[2..3])}
    </div>".html_safe
  end

  def code_text(code)
    str = code || "&nbsp;"
    "<div class='code-text pull-left'>#{str}</div>"
  end

  def tree_node(main_commodity, commodities, depth)
    deeper_node = commodities.select { |c| c.number_indents == depth + 1 }.first
    if deeper_node.present? && deeper_node.number_indents < main_commodity.number_indents
      content_tag(:ul) do
        content_tag(:li) do
          content_tag(:p, deeper_node.to_s.html_safe) +
          tree_code(deeper_node.code.gsub(/[0]{2}+$/, '')) + 
          # if deeper_node.producline_suffix == '80'
          #   tree_code(deeper_node.code.gsub(/[0]{2}+$/, ''))
          # end +
          tree_node(main_commodity, commodities, deeper_node.number_indents)
        end
      end
    else
      content_tag(:ul) do
        commodity_heading(main_commodity)
      end
    end
  end

  def commodity_heading(commodity)
    content_tag(:li, class: 'commodity-li') do
      content_tag(:div,
                  title: "Full tariff code: #{commodity.code}",
                  class: 'commodity-code',
                  'aria-describedby' => "commodity-#{commodity.code}") do
        content_tag(:div, format_commodity_code(commodity), class: 'code-text')
      end
      content_tag(:p, commodity.to_s.html_safe) +
      tree_commodity_code(commodity) +
      content_tag(:div, class: 'feed') do
        link_to('Changes', commodity_changes_path(commodity.declarable, format: :atom), rel: "nofollow")
      end
    end
  end

  def commodity_heading_full(commodity)
    content_tag(:li, class: 'commodity-li') do
      content_tag(:div,
                  title: "Full tariff code: #{commodity.code}",
                  class: 'full-code',
                  'aria-describedby' => "commodity-#{commodity.code}") do
        content_tag(:div, format_full_code(commodity), class: 'code-text')
      end
      content_tag(:p, commodity.to_s.html_safe) +
        content_tag(:div, class: 'feed') do
          link_to('Changes', commodity_changes_path(commodity.declarable, format: :atom), rel: "nofollow")
        end
    end
  end

  def declarable_heading(commodity)
    content_tag(:p) do
      content_tag(:p, commodity.formatted_description.html_safe,
                          class: 'description',
                          id: "commodity-#{commodity.code}") +
      tree_code(commodity.code)
    end
  end

  def declarable_heading_full(commodity)
    content_tag(:li, class: 'commodity-li') do
      content_tag(:p, format_full_code(commodity),
                         title: "Full tariff code: #{commodity.code}",
                         class: 'full-code',
                         'aria-describedby' => "commodity-#{commodity.code}") +
        content_tag(:p, commodity.to_s.html_safe)
    end
  end
end
