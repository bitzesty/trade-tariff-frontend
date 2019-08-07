require 'api_entity'

class Footnote
  include ApiEntity

  ECO_CODE = '05002'.freeze

  collection_path '/footnotes'

  attr_accessor :code, :description, :formatted_description

  has_many :measures

  def id
    @id ||= "#{casted_by.destination}-#{casted_by.id}-footnote-#{code}"
  end

  def eco?
    code == ECO_CODE
  end
end
