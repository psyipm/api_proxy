# frozen_string_literal: true

require 'spec_helper'
require 'rack'

RSpec.describe ApiProxy::Request do
  let(:config) { ApiProxy.configuration(:default) }

  let(:response_headers) { { 'Content-type' => 'application/json' } }
  let(:get_ticket_body) { File.read('spec/stubs/get_ticket_body.json') }

  let!(:get_ticket_stub) do
    stub_request(:get, Regexp.new('/api/v1/tickets/1'))
      .to_return(status: 200, body: get_ticket_body, headers: response_headers)
  end

  let!(:post_request_stub) do
    stub_request(:post, Regexp.new('/api/v1/tickets'))
      .with(body: 'subject=test')
      .to_return(status: 201, body: { status: :ok }.to_json, headers: response_headers)
  end

  def perform_request(env)
    builder = ApiProxy::RequestOptionsBuilder.new(env, config)
    request = described_class.new(builder)

    request.result
  end

  it 'should perform get request' do
    env = Rack::MockRequest.env_for('/_ts/tickets/1', 'REQUEST_METHOD' => 'GET')

    response = perform_request(env)

    expect(JSON.parse(response.to_s)).to eq JSON.parse(get_ticket_body)
    expect(response.code).to eq 200
    expect(response.headers).to eq response_headers
    expect(get_ticket_stub).to have_been_made.once
  end

  it 'should perform post request' do
    env = Rack::MockRequest.env_for('/_ts/tickets', 'REQUEST_METHOD' => 'POST')

    request = Rack::Request.new(env)
    request.update_param(:subject, :test)

    perform_request(request.env)

    expect(post_request_stub).to have_been_made.once
  end
end
