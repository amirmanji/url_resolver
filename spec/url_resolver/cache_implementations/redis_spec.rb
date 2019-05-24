require 'spec_helper'

describe UrlResolver::CacheImplementations::RedisCache do
  subject { UrlResolver::Cache.new(Redis.new) }
  
  describe '#set_url' do
    it 'calls #setex on the Redis instance with (key, ttl, value)' do
      expect_any_instance_of(Redis).to receive(:setex).with('key', 5, 'value')
      subject.set_url('key', 'value', 5)
    end
  end
  
  describe '#get_url' do
    it 'calls #get on the Redis instance with (key)' do
      expect_any_instance_of(Redis).to receive(:get).with('key')
      subject.get_url('key')
    end
    
    it 'returns the value stored in the Redis instance' do
      expect_any_instance_of(Redis).to receive(:get) { 'secret' }
      expect(subject.get_url('key')).to eq('secret')
    end
  end

end
