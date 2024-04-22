# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApiProxy::HeadersFilter do
  let(:valid_headers) { { 'content-type' => 'application/json' } }
  let(:headers) { valid_headers.merge('some-other-header' => 'value') }
  let(:allowed_headers) do
    [
      'content-type'
    ]
  end

  before(:each) do
    expect(valid_headers).to_not eq headers
  end

  it 'should filter headers' do
    expect(described_class.new(headers, allowed_headers).filter).to eq valid_headers
  end
end
