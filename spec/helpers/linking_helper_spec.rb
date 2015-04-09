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
        end

        it "replaces all the links" do
          expect(apply_links("heading 1 heading 2")).to \
            eq "heading #{number_to_heading_link(1)} heading #{number_to_heading_link(2)}"
        end

        it "replaces links between commas" do
          expect(apply_links("heading 1, 2")).to \
            eq "heading #{number_to_heading_link(1)}, #{number_to_heading_link(2)}"
        end

        it "replaces links using 'or'" do
          expect(apply_links("heading 1 or 2")).to \
            eq "heading #{number_to_heading_link(1)} or #{number_to_heading_link(2)}"
        end

        it "replaces links using 'and'" do
          expect(apply_links("heading 1 and 2")).to \
            eq "heading #{number_to_heading_link(1)} and #{number_to_heading_link(2)}"
        end

        it "stops after '.'" do
          expect(apply_links("heading 1. 2")).to \
            eq "heading #{number_to_heading_link(1)}. 2"
        end

        it "stops after any other word" do
          expect(apply_links("heading 1 stop 2")).to \
            eq "heading #{number_to_heading_link(1)} stop 2"
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
  end

  describe "number_to_heading_link" do
    it "generates a link" do
      expect(number_to_heading_link(1234)).to match /a href.*#{heading_path(1234)}.*1234/
    end
  end

  def should_not_change text
    expect(apply_links(text)).to eq(text)
  end
end
