# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApiProxy::RequestOptionsBuilder do
  let(:env) { { 'REQUEST_METHOD' => 'GET', 'REQUEST_PATH' => '/_ts/tickets/1' } }
  let(:config) { ApiProxy.configuration(:default) }
  let(:builder) { described_class.new(env, config) }

  it 'should build signature' do
    options = builder.options.stringify_keys

    expect(options.dig('headers', 'X-Access-Key')).to_not be_nil
    expect(options.dig('headers', 'X-Timestamp')).to_not be_nil
    expect(options.dig('headers', 'X-Signature')).to_not be_nil
  end

  it 'should build url' do
    expect(builder.url.to_s).to eq 'http://localhost:3000/api/v1/tickets/1'
  end
end
