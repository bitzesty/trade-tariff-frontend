module ApplicationHelper
  def govspeak(text)
    text = text['content'] || text[:content] if text.is_a?(Hash)
    return '' if text.nil?

    Govspeak::Document.new(text, sanitize: true).to_html.html_safe
  end

  def a_z_index(letter = 'a')
    ('a'..'z').map do |index_letter|
      content_tag(:li, class: ('active' if index_letter == letter).to_s) do
        link_to index_letter.upcase, a_z_index_path(letter: index_letter)
      end
    end.join.html_safe
  end

  def breadcrumbs
    return nil if %w(pages errors).exclude?(controller_name)

    crumbs = [
      content_tag(:li, link_to('Home', '/', class: "govuk-breadcrumbs__link"), class: "govuk-breadcrumbs__list-item"),
      content_tag(:li, link_to('Business and self-employed', 'https://www.gov.uk/browse/business', class: "govuk-breadcrumbs__link"), class: "govuk-breadcrumbs__list-item"),
      content_tag(:li, link_to('Imports and exports', 'https://www.gov.uk/browse/business/imports', class: "govuk-breadcrumbs__link"), class: "govuk-breadcrumbs__list-item")
    ]
    content_tag(:div, class: "govuk-breadcrumbs") do
      content_tag(:ol, crumbs.join('').html_safe, class: "govuk-breadcrumbs__list", role: "breadcrumbs")
    end
  end

  def govuk_header_navigation_item(active_class = false)
    base_classname = "govuk-header__navigation-item"
    classname = "#{base_classname} #{active_class ? "#{base_classname}--active" : ''}"
    content_tag(:li, class: classname) { yield }
  end

  def search_active_class
    'active' if params[:action] == 'search' || (params[:controller] == 'sections' && params[:action] == 'index')
  end

  def exchange_rates_active_class
    'active' if params[:controller] == 'exchange_rates'
  end

  def a_z_active_class
    'active' if params[:controller] == 'search_references'
  end

  def additional_code_search_class
    'active' if params[:action] == 'additional_code_search'
  end

  def footnote_search_class
    'active' if params[:action] == 'footnote_search'
  end

  def certificate_search_class
    'active' if params[:action] == 'certificate_search'
  end

  def quota_search_active_class
    'active' if params[:action] == 'quota_search'
  end

  def chemical_search_active_class
    'active' if params[:action] == 'chemical_search'
  end

  def currency_options
    [%w[Pound \sterling GBP], %w[Euro EUR]]
  end

  def download_chapter_pdf_url(section_position, chapter_code)
    pdf_urls = Rails.cache.fetch('cached_chapters_pdf_urls', expires_in: 1.hours) do
      TariffPdf.chapters.map(&:url)
    end

    currency = @search.attributes['currency'] || TradeTariffFrontend.currency_default

    pdf_urls.find do |url|
      url =~ /chapters\/#{currency.downcase}\/#{section_position.to_s.rjust(2, '0')}-#{chapter_code}\.pdf/
    end
  end

  def download_latest_pdf_url
    pdf_urls = Rails.cache.fetch('cached_latest_pdf_urls', expires_in: 1.hours) do
      TariffPdf.latest.map(&:url)
    end

    currency = @search.attributes['currency'] || TradeTariffFrontend.currency_default

    pdf_urls.find do |url|
      url =~ /#{currency.downcase}\//
    end
  end

  def chapter_forum_url(chapter)
    if chapter.forum_url.present?
      chapter.forum_url
    else
      "https://forum.trade-tariff.service.gov.uk/c/classification/chapter-#{chapter.short_code}"
    end
  end

  def current_url_without_parameters
    request.base_url + request.path
  end
end
