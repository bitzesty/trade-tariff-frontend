require 'spec_helper'

describe Search do
  it 'strips [ and ] characters from search term' do
    search = Search.new(q: '[hello] [world]')
    expect(search.q).to eq 'hello world'
  end

  describe 'raises on error if search responds with status 500' do
    let(:api_mock) { double(:api_mock) }
    let(:response_stub) { double(:response_stub, status: 500) }

    before do
      allow(api_mock).to receive(:post).and_return(response_stub)
      allow(Search).to receive(:api).and_return(api_mock)
    end

    it "search" do
      expect { Search.new(q: 'abc').perform }.to raise_error ApiEntity::Error
    end
  end
end
