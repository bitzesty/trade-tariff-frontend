require 'api_entity'

class TariffPdf
  include ApiEntity

  collection_path '/pdf/tariff'

  attr_accessor :date, :url

  def self.all
    collection('/pdf/tariff')
  end

  def self.latest
    collection('/pdf/latest')
  end

  def self.chapters
    collection('/pdf/chapters')
  end
end
