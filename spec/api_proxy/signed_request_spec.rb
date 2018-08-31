# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApiProxy::SignedRequest do
  let(:config) { ApiProxy.configuration(:default) }

  let(:get_ticket_body) { File.read('spec/stubs/get_ticket_body.json') }
  let(:response_headers) { { 'Content-type' => 'application/json' } }

  let!(:get_ticket_stub) do
    stub_request(:get, Regexp.new('/api/v1/tickets/1'))
      .with(headers: { 'X-Signature' => 'BRqJOmDxByLrMxfmACNtyTJVcV9Ncg17CsGd05Bgph8=' })
      .to_return(status: 200, body: get_ticket_body, headers: response_headers)
  end

  let!(:post_request_stub) do
    stub_request(:post, Regexp.new('/api/v1/tickets'))
      .with(
        body: 'subject=test',
        headers: { 'X-Signature' => 'vv2ZnWTiJmd2Um+RS8n3T31nPHqQ66/rvXvif4JMkqY=' }
      )
      .to_return(status: 201, body: { status: :ok }.to_json, headers: response_headers)
  end

  let(:timestamp) { '1535640662' }

  def perform_request(type, url, options = {})
    request = described_class.new(type, url, options)
    signature_options = request.send(:signature_options).merge(timestamp: timestamp)

    expect(request).to receive(:signature_options).and_return(signature_options)

    request.perform
  end

  it 'should perform get request with valid signature' do
    url = File.join(config.api_url.to_s, '/tickets/1')

    response = perform_request(:get, url)

    expect(JSON.parse(response.to_s)).to eq JSON.parse(get_ticket_body)
    expect(response.code).to eq 200
    expect(response.headers).to eq response_headers
    expect(get_ticket_stub).to have_been_requested.once
  end

  it 'should perform post request with valid signature' do
    url = File.join(config.api_url.to_s, '/tickets')

    perform_request(:post, url, body: { subject: :test })

    expect(post_request_stub).to have_been_requested.once
  end
end
