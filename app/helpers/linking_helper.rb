module LinkingHelper
  CONNECTORS = ['and', 'or', ',']

  def apply_links text
    LinkParser.new.execute(text)
  end

  def number_to_heading_link text, id=text
    link_to(text, heading_path(id))
  end

  def chapter_link id
    link_to("Chapter #{id}", chapter_path(id))
  end

  private

  class LinkParser
    attr_accessor :output

    def execute(text)
      self.output = Array.new
      @position = 0
      @parts = text.gsub(/([\.,])/, ' \1').split(" ")
      strategy = NilParserState.new

      while @position < @parts.count
        strategy = strategy.process(self)
      end

      output.join(" ").gsub(/ ([\.,])/, '\1')
    end

    def next
      @position += 1
    end

    def current
      @parts[@position]
    end
  end

  class ParserState
    include LinkingHelper
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def numeric? str
      return true if str =~ /^\d+$/
    end
  end

  class NilParserState < ParserState
    def process parser
      token = parser.current
      parser.output << parser.current
      parser.next

      if token.downcase == 'heading'
        return HeadingParserState.new
      elsif token.downcase == 'subheading'
        return SubheadingParserState.new
      elsif token.downcase == 'chapter'
        return ChapterParserState.new
      else
        return self
      end
    end
  end

  class HeadingParserState < ParserState
    def process parser
      if numeric? parser.current
        parser.output << number_to_heading_link(parser.current)
        parser.next
        return self
      elsif CONNECTORS.include? parser.current
        parser.output << parser.current
        parser.next
        return self
      else
        return NilParserState.new
      end
    end
  end

  class SubheadingParserState < ParserState
    def process parser
      if numeric? parser.current
        heading = parser.current
        parser.next
        if numeric? parser.current
          parser.output << number_to_heading_link("#{heading} #{parser.current}", heading)
          parser.next
          return self
        else
          parser.output << heading
          return NilParserState.new
        end
      elsif CONNECTORS.include? parser.current
        parser.output << parser.current
        parser.next
        return self
      else
        return NilParserState.new
      end
    end
  end

  class ChapterParserState < ParserState
    def process parser
      if numeric? parser.current
        parser.output.pop
        parser.output << chapter_link(parser.current)
        parser.next
      end
      return NilParserState.new
    end
  end
end