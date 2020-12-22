require 'api_entity'

class LegalAct
  include ApiEntity

  attr_accessor :regulation_code, :regulation_url, :validity_end_date,
                :validity_start_date, :published_date, :officialjournal_number, :officialjournal_page, :information_text

  def national_public_id
    return nil unless has_national_data?
    information_text&.split('|')&.first
  end

  def national_url
    return nil unless has_national_data?
    information_text&.split('|')&.fetch(1)
  end

  def national_information
    return nil unless has_national_data?
    information_text&.split('|')&.last
  end

  def validity_start_date=(date)
    @validity_start_date = Date.parse(date) if date.present?
  end

  def validity_end_date=(date)
    @validity_end_date = Date.parse(date) if date.present?
  end

  def url_safe_code
    regulation_code.tr("/", "_")
  end

  private

  def has_national_data?
    (information_text&.split('|')&.length || 0) == 3
  end
end
