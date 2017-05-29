require 'spec_helper'

describe Search do
  it 'strips [ and ] characters from search term' do
    search = Search.new(q: '[hello] [world]')
    expect(search.q).to eq 'hello world'
  end

  it 'raises on error if search responds with status 500' do
    response_stub = OpenStruct.new(code: 500)
    allow(Search).to receive(:post).and_return(response_stub)

    expect { Search.new(q: 'abc').perform }.to raise_error ApiEntity::Error
  end
end
