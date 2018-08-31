# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApiProxy::ResponseBuilder do
  let(:env) { Rack::MockRequest.env_for('/_ts/tickets', 'REQUEST_METHOD' => 'POST') }
  let(:request) { Rack::Request.new(env) }

  let!(:post_request_stub) do
    stub_request(:post, Regexp.new('/api/v1/tickets'))
      .with(body: 'subject=test')
  end

  let(:params) { { subject: 'test', commit: 'create', utf8: '✓' } }

  it 'should filter post params' do
    params.each do |key, value|
      request.update_param(key, value)
    end

    response = described_class.new(request.env).response

    expect(response.status).to eq 200
    expect(post_request_stub).to have_been_requested.once
  end
end
