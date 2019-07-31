module SearchResult
  class SectionSerializer < SimpleDelegator
    include ActiveModel::Serializers::JSON
    def serializable_hash(_opts = {})
      {
        type: 'section',
        numeral: numeral,
        position: position,
        title: title,
        section_note: section_note,
        chapter_from: chapter_from,
        chapter_to: chapter_to
      }
    end
  end
end
