require 'url_resolver'
require 'rspec'
require 'webmock/rspec'

class Redis; end

class FakeException < StandardError; end

WebMock.disable_net_connect!
