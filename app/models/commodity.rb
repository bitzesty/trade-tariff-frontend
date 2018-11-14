require 'api_entity'
require 'declarable'
require 'changeable'

class Commodity < GoodsNomenclature
  include Models::Changeable
  include Models::Declarable

  attr_accessor :parent_sid

  has_one :heading
  # vat_measure is used for commodities under the heading only
  has_many :additional_info_measures, class_name: 'Measure', wrapper: MeasureCollection
  has_many :ancestors, class_name: 'Commodity'

  delegate :goods_nomenclature_item_id, :display_short_code, to: :heading, prefix: true
  alias :short_code :goods_nomenclature_item_id

  def substring=(substring)
    @substring ||= substring.to_i
  end

  def leaf?
    children.none?
  end

  def has_children?
    not(leaf?)
  end

  def display_short_code
    code[4..-1]
  end

  def display_export_code
    code[0..-3]
  end

  def chapter_code
    code[0..1]
  end

  def heading_code
    code[2..3]
  end

  # There are no consigned declarable headings
  def consigned?
    consigned
  end

  def to_param
    code
  end

  def to_s
    formatted_description || description
  end

  def root
    parent_sid.blank?
  end

  def children
    if casted_by.present?
      casted_by.commodities.select { |c| c.parent_sid == goods_nomenclature_sid }
    else
      []
    end
  end

  def last_child?
    if casted_by.present?
      self.goods_nomenclature_sid == casted_by.commodities.select{|c| c.parent_sid == self.parent_sid }.last.goods_nomenclature_sid
    else
      false
    end
  end

  def consolidated_vat
    national_vat = additional_info_measures.vat

    return "" if national_vat.count == 0

    national_vat.map { |n| n.duty_expression.amount }.min.to_s + " %"
  end
end
