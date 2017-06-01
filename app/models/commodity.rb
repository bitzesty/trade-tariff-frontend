require 'api_entity'
require 'declarable'
require 'changeable'

class Commodity < GoodsNomenclature
  include Models::Changeable
  include Models::Declarable

  # TODO: remove after suggestions deploy
  collection_path '/commodities/codes'

  attr_accessor :parent_sid

  has_one :heading
  has_many :ancestors, class_name: 'Commodity'

  delegate :goods_nomenclature_item_id, :display_short_code, to: :heading, prefix: true
  alias :short_code :goods_nomenclature_item_id

  # TODO: remove after suggestions deploy
  def self.cached_commodities
    Rails.cache.fetch(
      'cached_commodities',
      expires_in: 24.hours
    ) do
      all
    end
  end
  # TODO: remove after suggestions deploy
  def self.by_code(code)
    cached_commodities.select do |commodity|
      commodity.code =~ /^#{code}/i
    end
  end

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

  def footnotes
    [import_measures.map(&:footnotes).select(&:present?) + export_measures.map(&:footnotes).select(&:present?)].flatten.uniq(&:code).sort_by(&:code)
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
end
