module LinkingHelper
  require 'strscan'
  CONNECTORS = ['and', 'or', 'to', ',', '']
  SUBSECTION_SEPARATOR = [' ']
  CHAPTER_SEPARATOR = [' ']

  def apply_links text
    LinkParser.new.execute(text)
  end

  def number_to_heading_link text, id = text
    link_to(text, heading_path(id))
  end

  def chapter_link id
    link_to(id, chapter_path(id))
  end

  private

  class LinkParser
    attr_accessor :output

    def execute(text)
      self.output = Array.new
      strategy = NilParserState.new

      @word = true
      @parts = StringScanner.new(text)
      self.next
      self.next if current.nil? # if starts with a symbol
      while !current.nil?
        strategy = strategy.process(self)
      end

      output.join
    end

    def next
      if @word
        @current = @parts.scan(/\w+/)
      else
        @current = @parts.scan(/\W+/)
      end
      @word = !@word
    end

    def current
      @current
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

      new_state = STATES[token.downcase.singularize]

      return new_state unless new_state.nil?
      return self
    end
  end

  class HeadingParserState < ParserState
    def process parser
      if numeric? parser.current
        parser.output << number_to_heading_link(parser.current)
        parser.next
        return self
      elsif CONNECTORS.include? parser.current.strip
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
        middle = parser.current
        parser.next
        if SUBSECTION_SEPARATOR.include?(middle) && numeric?(parser.current)
          parser.output << number_to_heading_link("#{heading}#{middle}#{parser.current}", heading)
          parser.next
          return self
        else
          parser.output << number_to_heading_link(heading, heading.to_s[0..3])
          parser.output << middle
          return NilParserState.new
        end
      elsif CONNECTORS.include? parser.current.strip
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
        parser.output << chapter_link(parser.current)
        parser.next
        return self
      elsif CONNECTORS.include? parser.current.strip
        parser.output << parser.current
        parser.next
        return self
      else
        return NilParserState.new
      end
    end
  end

  STATES = {
    'heading' => HeadingParserState.new,
    'subheading' => SubheadingParserState.new,
    'chapter' => ChapterParserState.new
  }
end