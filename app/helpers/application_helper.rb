module ApplicationHelper
  def govspeak(text)
    text = text['content'] || text[:content] if text.is_a?(Hash)
    return '' if text.nil?

    Govspeak::Document.new(text).to_sanitized_html.html_safe
  end

  def a_z_index(letter = 'a')
    ('a'..'z').map do |index_letter|
      content_tag(:li, class: ('active' if index_letter == letter).to_s) do
        link_to index_letter.upcase, a_z_index_path(letter: index_letter)
      end
    end.join.html_safe
  end

  def breadcrumbs
    return nil if controller_name == 'feedback'

    crumbs = [
      content_tag(:li, link_to('Home', '/')),
      content_tag(:li, link_to('Business and self-employed', 'https://www.gov.uk/browse/business')),
      content_tag(:li, link_to('Imports and exports', 'https://www.gov.uk/browse/business/imports'))
    ]
    content_tag(:ol, crumbs.join('').html_safe, role: "breadcrumbs")
  end

  def search_active_class
    active_class_for(controller_methods: %w[sections chapters headings commodities])
  end

  def exchange_rates_active_class
    active_class_for(controller_methods: %w[exchange_rates])
  end

  def a_z_active_class
    active_class_for(controller_methods: %w[search_references])
  end

  def quota_search_active_class
    "active" if params[:action] == 'quota_search'
  end

  def currency_options
    options = [%w[Euro EUR]]
    options << ['British Pound', 'GBP'] unless search_date_in_future_month?
    options
  end

  def change_currency_message
    search_date_in_future_month? ? "for a future date" : "Change currency"
  end

  private

  def active_class_for(controller_methods:)
    return "active" if controller_methods.include?(params[:controller])
  end

  def search_date_in_future_month?
    @search&.date.date >= Date.today.at_beginning_of_month.next_month
  end
end
