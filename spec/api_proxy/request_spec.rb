# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApiProxy::Request do
  let(:response_headers) { { 'Content-type' => 'application/json' } }
  let(:get_ticket_body) { File.read('spec/stubs/get_ticket_body.json') }

  before(:each) do
    stub_request(:get, 'http://localhost:3000/api/v1/tickets/1')
      .to_return(status: 200, body: get_ticket_body, headers: response_headers)
  end

  let(:env) { { 'REQUEST_METHOD' => 'GET', 'REQUEST_PATH' => '/_ts/tickets/1' } }
  let(:builder) { ApiProxy::RequestOptionsBuilder.new(env) }

  it 'should perform request' do
    request = described_class.new(builder)

    response = request.result

    expect(JSON.parse(response.to_s)).to eq JSON.parse(get_ticket_body)
    expect(response.code).to eq 200
    expect(response.headers).to eq response_headers
  end
end
