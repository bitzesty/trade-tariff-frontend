require 'api_entity'

class LegalAct
  include ApiEntity

  attr_accessor :regulation_code, :regulation_url, :validity_end_date,
                :validity_start_date, :published_date, :officialjournal_number, :officialjournal_page

  def validity_start_date=(date)
    @validity_start_date = Date.parse(date) if date.present?
  end

  def validity_end_date=(date)
    @validity_end_date = Date.parse(date) if date.present?
  end

  def url_safe_code
    regulation_code.tr("/", "_")
  end
end
