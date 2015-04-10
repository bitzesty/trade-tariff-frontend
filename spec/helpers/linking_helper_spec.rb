require 'spec_helper'

describe LinkingHelper, type: :helper do
  describe "apply_links" do
    context "without valid links" do
      it "always returns the same" do
        should_not_change "hello world"
        should_not_change "1234, 2020, 1800 or 4000"
        should_not_change "chapter and section"
      end
    end

    context "with heading" do
      context "with valid links" do
        it "returns heading links" do
          expect(apply_links("heading 1234")).to eq "heading #{number_to_heading_link(1234)}"
          expect(apply_links("Heading 1234")).to eq "Heading #{number_to_heading_link(1234)}"
        end

        it "works with parentheses" do
          expect(apply_links("(heading 1234)")).to eq "(heading #{number_to_heading_link(1234)})"
        end

        it "works with plural" do
          expect(apply_links("headings 1234")).to eq "headings #{number_to_heading_link(1234)}"
        end

        it "works with semicolon" do
          expect(apply_links("heading 1234;")).to eq "heading #{number_to_heading_link(1234)};"
        end

        it "works with html tags" do
          expect(apply_links("<b>heading 1234</b>")).to eq "<b>heading #{number_to_heading_link(1234)}</b>"
        end

        it "replaces all the links" do
          expect(apply_links("heading 1 heading 2")).to \
            eq "heading #{number_to_heading_link(1)} heading #{number_to_heading_link(2)}"
        end

        it "replaces links using connectors" do
          expect(apply_links("heading 1,2")).to \
            eq "heading #{number_to_heading_link(1)},#{number_to_heading_link(2)}"
          expect(apply_links("heading 1, 2")).to \
            eq "heading #{number_to_heading_link(1)}, #{number_to_heading_link(2)}"
          expect(apply_links("heading 1 or 2")).to \
            eq "heading #{number_to_heading_link(1)} or #{number_to_heading_link(2)}"
          expect(apply_links("heading 1 and 2")).to \
            eq "heading #{number_to_heading_link(1)} and #{number_to_heading_link(2)}"
        end

        it "stops after any other word or symbol" do
          expect(apply_links("heading 1 stop 2")).to \
            eq "heading #{number_to_heading_link(1)} stop 2"
          expect(apply_links("heading 1. 2")).to \
            eq "heading #{number_to_heading_link(1)}. 2"
        end
      end

      context "with invalid links" do
        it "always returns the same" do
          should_not_change "heading subheading chapter section"
          should_not_change "headingX1234"
          should_not_change "heading. 1234"
          should_not_change "noheading 1234"
        end
      end
    end

    context "with subheading" do
      context "with valid links" do
        it "returns heading links" do
          expect(apply_links("subheading 1234 50")).to eq "subheading #{number_to_heading_link('1234 50', 1234)}"
        end
        it "works with connectors" do
          expect(apply_links("subheading 1234 50, 1234 80")).to \
          eq "subheading #{number_to_heading_link('1234 50', 1234)}, #{number_to_heading_link('1234 80', 1234)}"
        end

        it "stops after any other word or symbol" do
          expect(apply_links("subheading 1 2 stop 2 3")).to \
            eq "subheading #{number_to_heading_link('1 2', 1)} stop 2 3"
          expect(apply_links("subheading 1 2. 2 3")).to \
            eq "subheading #{number_to_heading_link('1 2', 1)}. 2 3"
        end
      end

      context "with only 1 number" do
        it "does not add link for 4 digits" do
          should_not_change "subheading 1234. 50"
        end
      end
    end

    context "with chapter" do
      context "with valid link" do
        it "returns chapter links" do
          expect(apply_links("Chapter 50")).to eq "Chapter #{chapter_link(50)}"
        end
      end

      context "with connectors" do
        it "links every number" do
          expect(apply_links("Chapters 50 and 51")).to eq "Chapters #{chapter_link(50)} and #{chapter_link(51)}"
        end
      end

      context "with invalid link" do
        it "does not add any link" do
          should_not_change "chapter. 50"
        end
      end
    end
  end

  describe "number_to_heading_link" do
    it "generates a link" do
      expect(number_to_heading_link(1234)).to match /a href.*#{heading_path(1234)}.*1234/
    end
  end

  describe "chapter_link" do
    it "generates a link" do
      expect(chapter_link(1234)).to match /a href.*#{chapter_path(1234)}.*1234/
    end
  end

  def should_not_change text
    expect(apply_links(text)).to eq(text)
  end
end
