require 'api_entity'
require 'changeable'

class Chapter < GoodsNomenclature
  include ApiEntity
  include Models::Changeable

  attr_accessor :headings, :chapter_note

  has_one :section
  has_many :headings

  delegate :numeral, to: :section, prefix: true

  alias :code :goods_nomenclature_item_id

  def short_code
    code.first(2)
  end

  def to_param
    short_code
  end

  def to_s
    formatted_description || description
  end

  def guides
    attributes['guides']
  end
end
