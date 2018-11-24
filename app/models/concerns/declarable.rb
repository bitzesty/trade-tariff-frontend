module Models
  module Declarable
    extend ActiveSupport::Concern

    included do
      include ApiEntity

      has_one :section
      has_one :chapter
      has_many :footnotes
      has_many :import_measures, class_name: 'Measure',
                                 wrapper: MeasureCollection
      has_many :export_measures, class_name: 'Measure',
                                 wrapper: MeasureCollection

      attr_accessor :description, :goods_nomenclature_item_id,
                    :number_indents, :goods_nomenclature_sid, :bti_url, :description_plain,
                    :formatted_description, :consigned, :consigned_from, :basic_duty_rate,
                    :meursing_code, :producline_suffix

      delegate :numeral, to: :section, prefix: true
      delegate :code, :short_code, to: :chapter, prefix: true
    end

    def meursing_code?
      meursing_code
    end

    def code
      goods_nomenclature_item_id
    end

    def all_footnotes
      (
        footnotes +
        export_measures.map(&:footnotes).select(&:present?).flatten +
        import_measures.map(&:footnotes).select(&:present?).flatten
      ).uniq(&:code)
    end
  end
end
