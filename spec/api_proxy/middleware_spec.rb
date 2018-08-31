# frozen_string_literal: true

require 'spec_helper'
require 'rack'

RSpec.describe ApiProxy::Middleware do
  let(:app) { OpenStruct.new(call: 'test') }
  let(:middleware) { described_class.new(app) }

  context 'get' do
    let(:env) { Rack::MockRequest.env_for('/_ts/tickets/1', 'REQUEST_METHOD' => 'GET') }

    let!(:get_ticket_stub) { stub_request(:get, Regexp.new('/api/v1/tickets/1')) }

    it 'should forward request' do
      middleware.call(env)

      expect(get_ticket_stub).to have_been_requested.once
    end
  end

  context 'post' do
    let(:env) { Rack::MockRequest.env_for('/_ts/tickets', 'REQUEST_METHOD' => 'POST') }

    let!(:post_request_stub) { stub_request(:post, Regexp.new('/api/v1/tickets')) }

    it 'should forward request' do
      middleware.call(env)

      expect(post_request_stub).to have_been_requested.once
    end
  end
end
